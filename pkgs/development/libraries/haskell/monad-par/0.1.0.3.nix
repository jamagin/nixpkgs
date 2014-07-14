# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, deepseq, HUnit }:

cabal.mkDerivation (self: {
  pname = "monad-par";
  version = "0.1.0.3";
  sha256 = "1c0yclil152hv06c2sbgam9amd63nnzh7a4xsnxb05wgy93qs2mg";
  buildDepends = [ deepseq HUnit ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/simonmar/monad-par";
    description = "A library for parallel programming based on a monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
