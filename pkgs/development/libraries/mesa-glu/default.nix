{ stdenv, fetchurl, pkgconfig, mesa }:

stdenv.mkDerivation rec {
  name = "glu-9.0.0";

  src = fetchurl {
    url = "ftp://ftp.freedesktop.org/pub/mesa/glu/${name}.tar.bz2";
    sha256 = "04nzlil3a6fifcmb95iix3yl8mbxdl66b99s62yzq8m7g79x0yhz";
  };

  buildInputs = [ pkgconfig mesa ];

  meta = {
    description = "OpenGL utility library";
    homepage = http://cgit.freedesktop.org/mesa/glu/;
    license = "bsd"; # SGI-B-2.0, which seems BSD-like
  };
}
