# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal }:

cabal.mkDerivation (self: {
  pname = "greencard";
  version = "3.0.4.2";
  sha256 = "1vl9p6mqss5r4jfqnjir7m1q7fhh9f204c99qd5y5d0j7yc26r5y";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "https://github.com/sof/greencard";
    description = "GreenCard, a foreign function pre-processor for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
