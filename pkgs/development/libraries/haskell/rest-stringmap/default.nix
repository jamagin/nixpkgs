{ cabal, aeson, hashable, hxt, jsonSchema, tagged, text, tostring
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "rest-stringmap";
  version = "0.2.0.2";
  sha256 = "0nzkc09679c2mz3amh1avk2kfjpqbhbxsr0r9zvgcs71gqkal2mz";
  buildDepends = [
    aeson hashable hxt jsonSchema tagged text tostring
    unorderedContainers
  ];
  meta = {
    description = "Maps with stringy keys that can be transcoded to JSON and XML";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
