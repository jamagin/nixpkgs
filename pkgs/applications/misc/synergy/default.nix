{ stdenv, fetchurl, cmake, x11, libX11, libXi, libXtst, cryptopp }:

stdenv.mkDerivation rec {
  name = "synergy-1.4.12";

  src = fetchurl {
  	url = "http://synergy.googlecode.com/files/${name}-Source.tar.gz";
  	sha256 = "0j884skwqy8r8ckj9a4rlwsbjwb1yrj9wqma1nwhr2inff6hrdim";
  };

  patches = [ ./cryptopp.patch ];

  buildInputs = [ cmake x11 libX11 libXi libXtst cryptopp ];

  # At this moment make install doesn't work for synergy
  # http://synergy-foss.org/spit/issues/details/3317/

  installPhase = ''
    ensureDir $out/bin
    cp ../bin/synergyc $out/bin
    cp ../bin/synergys $out/bin
    cp ../bin/synergyd $out/bin
  '';

  meta = {
    description = "Tool to share the mouse keyboard and the clipboard between computers";
    homepage = http://synergy-foss.org;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
  };
}
