{ stdenv, fetchurl, makeFontsConf, makeWrapper
, cairo, coreutils, fontconfig, freefont_ttf
, glib, gmp, gtk2, libffi, libjpeg, libpng
, libtool, mpfr, openssl, pango, poppler
, readline, sqlite
, disableDocs ? true
}:

let

  fontsConf = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };

  libPath = stdenv.lib.makeLibraryPath [
    cairo
    fontconfig
    glib
    gmp
    gtk2
    libjpeg
    libpng
    mpfr
    openssl
    pango
    poppler
    readline
    sqlite
  ];

in

stdenv.mkDerivation rec {
  name = "racket-${version}";
  version = "6.8";

  src = fetchurl {
    url = "http://mirror.racket-lang.org/installers/${version}/${name}-src.tgz";
    sha256 = "1l9z1a0r5zydr50cklx9xjw3l0pwnf64i10xq7112fl1r89q3qgv";
  };

  FONTCONFIG_FILE = fontsConf;
  LD_LIBRARY_PATH = libPath;
  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.cc.isGNU "-lgcc_s";

  buildInputs = [ fontconfig libffi libtool makeWrapper sqlite ];

  preConfigure = ''
    substituteInPlace src/configure --replace /usr/bin/uname ${coreutils}/bin/uname
    mkdir src/build
    cd src/build
  '';

  shared = if stdenv.isDarwin then "dylib" else "shared";
  configureFlags = [ "--enable-${shared}" "--enable-lt=${libtool}/bin/libtool" ]
                   ++ stdenv.lib.optional disableDocs [ "--disable-docs" ]
                   ++ stdenv.lib.optional stdenv.isDarwin [ "--enable-xonx" ];

  configureScript = "../configure";

  enableParallelBuilding = false;

  postInstall = ''
    for p in $(ls $out/bin/) ; do
      wrapProgram $out/bin/$p --set LD_LIBRARY_PATH "${LD_LIBRARY_PATH}";
    done
  '';

  meta = with stdenv.lib; {
    description = "A programmable programming language";
    longDescription = ''
      Racket is a full-spectrum programming language. It goes beyond
      Lisp and Scheme with dialects that support objects, types,
      laziness, and more. Racket enables programmers to link
      components written in different dialects, and it empowers
      programmers to create new, project-specific dialects. Racket's
      libraries support applications from web servers and databases to
      GUIs and charts.
    '';
    homepage = http://racket-lang.org/;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ kkallio henrytill vrthra ];
    platforms = platforms.x86_64;
  };
}
