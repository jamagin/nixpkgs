# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, haskellSrcExts, HUnit, QuickCheck, transformers }:

cabal.mkDerivation (self: {
  pname = "pointfree";
  version = "1.0.4.8";
  sha256 = "0nb3mqp6zwnnq6fs27xhcqv4w8h6sr5k01hldkqnkgwz0yyy7ljy";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ haskellSrcExts transformers ];
  testDepends = [ haskellSrcExts HUnit QuickCheck transformers ];
  jailbreak = true;
  meta = {
    description = "Tool for refactoring expressions into pointfree form";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
  };
})
