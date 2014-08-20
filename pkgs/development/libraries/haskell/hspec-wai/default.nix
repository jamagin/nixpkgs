# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, aesonQq, caseInsensitive, doctest, hspec2
, hspecMeta, httpTypes, markdownUnlit, scotty, text, transformers
, wai, waiExtra
}:

cabal.mkDerivation (self: {
  pname = "hspec-wai";
  version = "0.3.0";
  sha256 = "0wkzv406jiyi8ais3g0addm66274y1pvy55gypmnhwx5rp2kr6fb";
  buildDepends = [
    aeson aesonQq caseInsensitive hspec2 httpTypes text transformers
    wai waiExtra
  ];
  testDepends = [
    aeson caseInsensitive doctest hspec2 hspecMeta httpTypes
    markdownUnlit scotty text transformers wai waiExtra
  ];
  meta = {
    description = "Experimental Hspec support for testing WAI applications (depends on hspec2!)";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
