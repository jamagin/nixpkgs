{ stdenv, fetchurl
, boost, freeglut, glew, gsl, lcms2, libpng, libtiff, libxmi, mesa, vigra
, pkgconfig, perl }:

stdenv.mkDerivation rec {
  name = "enblend-enfuse-4.1.3";

  src = fetchurl {
    url = "mirror://sourceforge/enblend/${name}.tar.gz";
    sha256 = "1b7r1nnwaind0344ckwggy0ghl0ipbk9jzylsxcjfl05rnasw00w";
  };

  buildInputs = [ boost freeglut glew gsl lcms2 libpng libtiff libxmi mesa vigra ];

  nativeBuildInputs = [ perl pkgconfig ];

  meta = {
    homepage = http://enblend.sourceforge.net/;
    description = "Blends away the seams in a panoramic image mosaic using a multiresolution spline";
    license = "GPLv2";
  };
}
