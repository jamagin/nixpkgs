# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, attoparsec, scientific, text }:

cabal.mkDerivation (self: {
  pname = "aeson-utils";
  version = "0.2.2.1";
  sha256 = "0sj4kdcxcj2wnf3s109yxq8gghz976hkiqs19bjcp6qkzdf5w6sd";
  buildDepends = [ aeson attoparsec scientific text ];
  jailbreak = true;
  meta = {
    description = "Utilities for working with Aeson";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ aycanirican ];
  };
})
