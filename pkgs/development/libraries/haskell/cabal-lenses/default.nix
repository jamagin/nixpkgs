# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, Cabal, lens, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "cabal-lenses";
  version = "0.4.1";
  sha256 = "0gkd82g6q8ahrrfmnjzr4r9n5cgdmhpxkqvnsy50k043v0faa0cx";
  buildDepends = [ Cabal lens unorderedContainers ];
  jailbreak = true;
  meta = {
    description = "Lenses and traversals for the Cabal library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
