# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, alex, filepath, happy, syb }:

cabal.mkDerivation (self: {
  pname = "language-c";
  version = "0.4.6";
  sha256 = "0pzd3g5q3sjfngs29biannza6l9am75kcjy5q0xcjv7xhz0z1m31";
  buildDepends = [ filepath syb ];
  buildTools = [ alex happy ];
  meta = {
    homepage = "http://www.sivity.net/projects/language.c/";
    description = "Analysis and generation of C code";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
