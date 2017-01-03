{ stdenv, fetchurl
, qt4 ? null, qmake4Hook ? null
, withQt5 ? false, qtbase ? null, qmakeHook ? null
}:

stdenv.mkDerivation rec {
  pname = "qscintilla";
  version = "2.9";

  name = "${pname}-${if withQt5 then "qt5" else "qt4"}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/QScintilla2/QScintilla-${version}/QScintilla-gpl-${version}.tar.gz";
    sha256 = "d7c32e32582f93779de861006d87467b38b9ebc06e3d0b32e981cb24369fa417";
  };

  buildInputs = if withQt5 then [ qtbase ] else [ qt4 ];
  nativeBuildInputs = if withQt5 then [ qmakeHook ] else [ qmake4Hook ];

  enableParallelBuilding = true;

  preConfigure = ''
    cd Qt4Qt5
    sed -i -e "s,\$\$\\[QT_INSTALL_LIBS\\],$out/lib," \
           -e "s,\$\$\\[QT_INSTALL_HEADERS\\],$out/include/," \
           -e "s,\$\$\\[QT_INSTALL_TRANSLATIONS\\],$out/share/qt/translations," \
           -e "s,\$\$\\[QT_INSTALL_DATA\\],$out/share/qt," \
           qscintilla.pro
  '';

  meta = with stdenv.lib; {
    description = "A Qt port of the Scintilla text editing library";
    longDescription = ''
      QScintilla is a port to Qt of Neil Hodgson's Scintilla C++ editor
      control.

      As well as features found in standard text editing components,
      QScintilla includes features especially useful when editing and
      debugging source code. These include support for syntax styling,
      error indicators, code completion and call tips. The selection
      margin can contain markers like those used in debuggers to
      indicate breakpoints and the current line. Styling choices are
      more open than with many editors, allowing the use of
      proportional fonts, bold and italics, multiple foreground and
      background colours and multiple fonts.
    '';
    homepage = http://www.riverbankcomputing.com/software/qscintilla/intro;
    license = with licenses; [ gpl2 gpl3 ]; # and commercial
    platforms = platforms.unix;
  };
}
