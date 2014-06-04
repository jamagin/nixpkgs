{ stdenv, fetchurl }:

let version = "20030809";
in
stdenv.mkDerivation {
  name = "kochi-substitute-${version}";

  src = fetchurl {
    url = "http://jaist.dl.sourceforge.jp/efont/5411/kochi-substitute-${version}.tar.bz2";
    sha256 = "f4d69b24538833bf7e2c4de5e01713b3f1440960a6cc2a5993cb3c68cd23148c";
  };

  sourceRoot = "kochi-substitute-${version}";

  installPhase =
  ''
    mkdir -p $out/share/fonts/kochi-substitute
    cp *.ttf $out/share/fonts/kochi-substitute
  '';

  meta = {
    description = "Japanese font, a free replacement for MS Gothic and MS Mincho.";
    homepage = http://sourceforge.jp/projects/efont/;
  };
}
