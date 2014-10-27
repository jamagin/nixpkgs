# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, ansiTerminal, async, deepseq, filepath, hspecExpectations
, HUnit, QuickCheck, quickcheckIo, random, setenv, tfRandom, time
, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec-meta";
  version = "1.12.1";
  sha256 = "1920gpcam7y3slg1an8ywhw6lxammgy21nmxbxlh77iz65rldzls";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal async deepseq filepath hspecExpectations HUnit
    QuickCheck quickcheckIo random setenv tfRandom time transformers
  ];
  doCheck = false;
  meta = {
    homepage = "http://hspec.github.io/";
    description = "A version of Hspec which is used to test Hspec itself";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
