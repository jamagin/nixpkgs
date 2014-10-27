# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, attoparsec, cmdargs, dyre, filepath, haskellSrcExts, lens
, mtl, split, tasty, tastyGolden, text
}:

cabal.mkDerivation (self: {
  pname = "hsimport";
  version = "0.6.2";
  sha256 = "02v32gh5has3y8qk55cpdr0336n2hi33d5aw0ifpg84p89k8kr33";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec cmdargs dyre haskellSrcExts lens mtl split text
  ];
  testDepends = [ filepath haskellSrcExts tasty tastyGolden ];
  jailbreak = true;
  meta = {
    description = "A command line program for extending the import list of a Haskell source file";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ ocharles ];
  };
})
