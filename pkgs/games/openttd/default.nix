{ stdenv, fetchurl, pkgconfig, SDL, libpng, zlib, xz, freetype, fontconfig }:

stdenv.mkDerivation rec {
  name = "openttd-${version}";
  version = "1.4.0";

  src = fetchurl {
    url = "http://binaries.openttd.org/releases/${version}/${name}-source.tar.xz";
    sha256 = "0m89pr7m7xg71q1j3869dfrbhv88g90cw9zn0jlpg8crsj4wnnyq";
  };

  buildInputs = [ SDL libpng pkgconfig xz zlib freetype fontconfig ];
  prefixKey = "--prefix-dir=";

  configureFlags = [
    "--with-zlib=${zlib}/lib/libz.a"
    "--without-liblzo2"
  ];

  makeFlags = "INSTALL_PERSONAL_DIR=";

  postInstall = ''
    mv $out/games/ $out/bin
  '';

  meta = {
    description = ''OpenTTD is an open source clone of the Microprose game "Transport Tycoon Deluxe"'';
    longDescription = ''
      OpenTTD is a transportation economics simulator. In single player mode,
      players control a transportation business, and use rail, road, sea, and air
      transport to move goods and people around the simulated world.

      In multiplayer networked mode, players may:
        - play competitively as different businesses
        - play cooperatively controling the same business
        - observe as spectators
    '';
    homepage = http://www.openttd.org/;
    license = "GPLv2";
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ jcumming the-kenny ];
  };
}
