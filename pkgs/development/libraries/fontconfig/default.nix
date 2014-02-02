{ stdenv, fetchurl, pkgconfig, freetype, expat }:

stdenv.mkDerivation rec {
  name = "fontconfig-2.11.0";

  src = fetchurl {
    url = "http://fontconfig.org/release/${name}.tar.bz2";
    sha256 = "0rx4q7wcrz4lkpgcmqkwkp49v1fm0yxl0f35jn75dj1vy3v0w3nb";
  };

  infinality_patch = with freetype.infinality; if useInfinality
    then let subvers = "1";
      in fetchurl {
        url = http://www.infinality.net/fedora/linux/zips/fontconfig-infinality-1-20130104_1.tar.bz2;
        sha256 = "1fm5xx0mx2243jrq5rxk4v0ajw2nawpj23399h710bx6hd1rviq7";
      }
    else null;

  buildInputs = [ pkgconfig freetype expat ];

  configureFlags = "--sysconfdir=/etc --with-cache-dir=/var/cache/fontconfig --disable-docs --with-default-fonts=";

  # We should find a better way to access the arch reliably.
  crossArch = stdenv.cross.arch or null;

  preConfigure = ''
    if test -n "$crossConfig"; then
      configureFlags="$configureFlags --with-arch=$crossArch";
    fi
  '';

  enableParallelBuilding = true;

  # Don't try to write to /etc/fonts or /var/cache/fontconfig at install time.
  installFlags = "sysconfdir=$(out)/etc RUN_FC_CACHE_TEST=false fc_cachedir=$(TMPDIR)/dummy";

  postInstall = stdenv.lib.optionalString freetype.infinality.useInfinality ''
    cd "$out/etc/fonts" && tar xvf ${infinality_patch}
  '';

  meta = {
    description = "A library for font customization and configuration";
    homepage = http://fontconfig.org/;
    license = "bsd";
    platforms = stdenv.lib.platforms.all;
  };
}
