# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, abstractDeque, abstractPar, deepseq, HUnit, monadParExtras
, mtl, mwcRandom, parallel, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, testFrameworkTh
, time
}:

cabal.mkDerivation (self: {
  pname = "monad-par";
  version = "0.3.4.7";
  sha256 = "12n27hs274nrfkpa6hx0gdkrc76wxzliqf53x6689idl363sdf13";
  buildDepends = [
    abstractDeque abstractPar deepseq monadParExtras mtl mwcRandom
    parallel
  ];
  testDepends = [
    abstractDeque abstractPar deepseq HUnit monadParExtras mtl
    mwcRandom QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 testFrameworkTh time
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/simonmar/monad-par";
    description = "A library for parallel programming based on a monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
