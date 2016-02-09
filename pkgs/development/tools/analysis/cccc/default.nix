{ stdenv, fetchurl }:

let
  name = "cccc";
  version = "3.1.4";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${version}/${name}-${version}.tar.gz";
    sha256 = "1gsdzzisrk95kajs3gfxks3bjvfd9g680fin6a9pjrism2lyrcr7";
  };

  hardening_format = false;

  patches = [ ./cccc.patch ];

  preConfigure = ''
    substituteInPlace install/install.mak --replace /usr/local/bin $out/bin
    substituteInPlace install/install.mak --replace MKDIR=mkdir "MKDIR=mkdir -p"
  '';

  meta = {
    description = "C and C++ Code Counter";
    longDescription = ''
      CCCC is a tool which analyzes C++ and Java files and generates a report
      on various metrics of the code. Metrics supported include lines of code, McCabe's
      complexity and metrics proposed by Chidamber&Kemerer and Henry&Kafura.
    '';
    homepage = "http://cccc.sourceforge.net/";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.linquize ];
  };
}
