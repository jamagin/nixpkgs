# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, attoparsec, genericDeriving, mtl, tagged, text
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "generic-aeson";
  version = "0.2.0.1";
  sha256 = "0k5zkfmwffdv4q0c9zgysq4654gjwnz1nbl37y8aq7g3rsfzfbf5";
  buildDepends = [
    aeson attoparsec genericDeriving mtl tagged text
    unorderedContainers vector
  ];
  meta = {
    description = "Derivation of Aeson instances using GHC generics";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ aycanirican ];
  };
})
