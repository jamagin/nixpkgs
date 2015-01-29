{ stdenv, fetchFromGitHub, nodejs, which, python27, utillinux }:

let
  version = "15"; # see ${src}/util/version/Version.h
  date = "20150129";
in
stdenv.mkDerivation {
  name = "cjdns-${version}-${date}";

  src = fetchFromGitHub {
    owner = "cjdelisle";
    repo = "cjdns";
    rev = "97161a5fef6b98ffbba94888587bd9ce733c2278";
    sha256 = "0wxiwgjcl4rn71b6hjdlfgv9hjy9d43sypikzcl5z65r7xkrb41j";
  };

  buildInputs = [ which python27 nodejs ] ++
    # for flock
    stdenv.lib.optional stdenv.isLinux [ utillinux ];

  buildPhase = "bash do";
  installPhase = ''
    installBin cjdroute makekeys privatetopublic publictoip6
    sed -i 's,/usr/bin/env node,'$(type -P node), \
      $(find contrib -name "*.js")
    sed -i 's,/usr/bin/env python,'$(type -P python), \
      $(find contrib -type f)
    mkdir -p $out/share/cjdns
    cp -R contrib node_build node_modules $out/share/cjdns/
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/cjdelisle/cjdns;
    description = "Encrypted networking for regular people";
    license = licenses.gpl3;
    maintainers = with maintainers; [ viric emery ];
    platforms = platforms.unix;
  };
}
