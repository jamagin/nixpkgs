# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, deepseq, Diff, dualTree, filepath, ghcMod, ghcPaths
, ghcSybUtils, haskellTokenUtils, hslogger, hspec, HUnit
, monoidExtras, mtl, parsec, QuickCheck, rosezipper, semigroups
, silently, StrafunskiStrategyLib, stringbuilder, syb, syz, time
, transformers
}:

cabal.mkDerivation (self: {
  pname = "HaRe";
  version = "0.7.2.6";
  sha256 = "0fvnif75sjgi4388in8fdvgvaxb0s9cgnqf7i583rxlxjibx44ai";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    dualTree filepath ghcMod ghcPaths ghcSybUtils haskellTokenUtils
    hslogger monoidExtras mtl parsec rosezipper semigroups
    StrafunskiStrategyLib syb syz time transformers
  ];
  testDepends = [
    deepseq Diff dualTree filepath ghcMod ghcPaths ghcSybUtils
    haskellTokenUtils hslogger hspec HUnit monoidExtras mtl QuickCheck
    rosezipper semigroups silently StrafunskiStrategyLib stringbuilder
    syb syz time transformers
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/RefactoringTools/HaRe/wiki";
    description = "the Haskell Refactorer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    hydraPlatforms = self.stdenv.lib.platforms.none;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
