# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, ansiTerminal, async, deepseq, doctest, filepath, ghcPaths
, hspecExpectations, hspecMeta, HUnit, QuickCheck, quickcheckIo
, random, setenv, silently, tfRandom, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec";
  version = "1.11.0";
  sha256 = "1hkflasm7w9z0b1c1mq3rl5pq05np27sz3p2s61bick371qi9zsf";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal async deepseq filepath hspecExpectations HUnit
    QuickCheck quickcheckIo random setenv tfRandom time transformers
  ];
  testDepends = [
    ansiTerminal async deepseq doctest filepath ghcPaths
    hspecExpectations hspecMeta HUnit QuickCheck quickcheckIo random
    setenv silently tfRandom time transformers
  ];
  doCheck = false;
  meta = {
    homepage = "http://hspec.github.io/";
    description = "Behavior-Driven Development for Haskell";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
