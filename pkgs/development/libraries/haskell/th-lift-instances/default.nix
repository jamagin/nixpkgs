# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, doctest, filepath, QuickCheck, text, thLift, vector }:

cabal.mkDerivation (self: {
  pname = "th-lift-instances";
  version = "0.1.4";
  sha256 = "02sf7qn1rs33cdf1dl7vpwkhqzhmj8h3naw0ngh2kz05ymk2qng4";
  buildDepends = [ text thLift vector ];
  testDepends = [ doctest filepath QuickCheck text vector ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/bennofs/th-lift-instances/";
    description = "Lift instances for template-haskell for common data types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
