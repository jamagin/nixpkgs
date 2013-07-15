{ stdenv, fetchurl, libX11, pkgconfig, libXext, mesa, libdrm, libXfixes }:

stdenv.mkDerivation rec {
  name = "libva-1.2.1";
  
  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva/${name}.tar.bz2";
    sha1 = "f716a4cadd670b14f44a2e833f96a2c509956339";
  };

  buildInputs = [ libX11 libXext pkgconfig mesa libdrm libXfixes ];

  configureFlags = [ "--enable-glx" ];

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/vaapi;
    license = "MIT";
    description = "VAAPI library: Video Acceleration API";
  };
}
