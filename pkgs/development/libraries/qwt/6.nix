{ stdenv, fetchurl, qt5 }:

stdenv.mkDerivation rec {
  name = "qwt-6.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/qwt/${name}.tar.bz2";
    sha256 = "031x4hz1jpbirv9k35rqb52bb9mf2w7qav89qv1yfw1r3n6z221b";
  };

  propagatedBuildInputs = [ qt5.base qt5.svg qt5.tools ];

  postPatch = ''
    sed -e "s|QWT_INSTALL_PREFIX.*=.*|QWT_INSTALL_PREFIX = $out|g" -i qwtconfig.pri
  '';

  configurePhase = "qmake -after doc.path=$out/share/doc/${name} -r";

  meta = with stdenv.lib; {
    description = "Qt widgets for technical applications";
    homepage = http://qwt.sourceforge.net/;
    # LGPL 2.1 plus a few exceptions (more liberal)
    license = stdenv.lib.licenses.qwt;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
    branch = "6";
  };
}
