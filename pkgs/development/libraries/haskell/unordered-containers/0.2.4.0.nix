# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, ChasingBottoms, deepseq, hashable, HUnit, QuickCheck
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "unordered-containers";
  version = "0.2.4.0";
  sha256 = "1x6djgmawzq8i8spib729pdlpnxyi4gz4p08lyn6jhfqjq6fpsil";
  buildDepends = [ deepseq hashable ];
  testDepends = [
    ChasingBottoms hashable HUnit QuickCheck testFramework
    testFrameworkHunit testFrameworkQuickcheck2
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/tibbe/unordered-containers";
    description = "Efficient hashing-based container types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
