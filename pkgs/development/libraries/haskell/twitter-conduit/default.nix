# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, attoparsec, authenticateOauth, caseInsensitive
, conduit, conduitExtra, dataDefault, doctest, filepath, hlint
, hspec, httpClient, httpConduit, httpTypes, lens, lensAeson
, monadControl, networkUri, resourcet, text, time, transformers
, transformersBase, twitterTypes, twitterTypesLens
}:

cabal.mkDerivation (self: {
  pname = "twitter-conduit";
  version = "0.1.0";
  sha256 = "1cymgp3wlswxn5qfdr442cqq2ak48b5w1zcsr67n2g5p1izadwji";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec authenticateOauth conduit conduitExtra dataDefault
    httpClient httpConduit httpTypes lens lensAeson networkUri
    resourcet text time transformers twitterTypes twitterTypesLens
  ];
  testDepends = [
    aeson attoparsec authenticateOauth caseInsensitive conduit
    conduitExtra dataDefault doctest filepath hlint hspec httpClient
    httpConduit httpTypes lens lensAeson monadControl networkUri
    resourcet text time transformers transformersBase twitterTypes
    twitterTypesLens
  ];
  meta = {
    homepage = "https://github.com/himura/twitter-conduit";
    description = "Twitter API package with conduit interface and Streaming API support";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ ocharles ];
  };
})
