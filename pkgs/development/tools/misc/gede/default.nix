{ stdenv, fetchurl, ctags, qt4, python }:

stdenv.mkDerivation rec {
  name = "gede-${version}";
  version = "2.0.3";

  src = fetchurl {
    url = "http://gede.acidron.com/uploads/source/${name}.tar.xz";
    sha256 = "1znlmkjgrmjl79q73xaa9ybp1xdc3k4h4ynv3jj5z8f92gjnj3kk";
  };

  nativeBuildInputs = [ python ];

  buildInputs = [ ctags qt4 ];

  postPatch = ''
    sed -i build.py -e 's,qmake-qt4,qmake,'
  '';

  buildPhase = ":";

  installPhase = ''
    python build.py install --prefix="$out"
  '';

  meta = with stdenv.lib; {
    description = "Graphical frontend (GUI) to GDB";
    homepage = "http://gede.acidron.com";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ juliendehos ];
  };
}
