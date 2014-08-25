# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, attoparsec, doctest, exceptions, filepath
, httpClient, httpClientTls, httpTypes, HUnit, lens, mimeTypes
, temporary, testFramework, testFrameworkHunit, text, time
, fetchpatch
}:

cabal.mkDerivation (self: {
  pname = "wreq";
  version = "0.1.0.1";
  sha256 = "05w3b555arsab8a5w73nm9pk3p9r6jipi6cd3ngxv48gdn9wzhvz";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec exceptions httpClient httpClientTls httpTypes lens
    mimeTypes text time
  ];
  testDepends = [
    aeson doctest filepath httpClient httpTypes HUnit lens temporary
    testFramework testFrameworkHunit text
  ];
  doCheck = false;
  meta = {
    homepage = "http://www.serpentine.com/wreq";
    description = "An easy-to-use HTTP client library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ ocharles ];
  };
  patches = [
    (fetchpatch { url = https://github.com/bos/wreq/commit/e8e29b62006e39ab36ffbb1d18c3e9d5923158ac.patch; sha256 = "19kqy512sa4dbzqp7kmjpsnsmc63wqh5pkh6hcvkzsji15dmlqrg"; })
    (fetchpatch { url = https://github.com/bos/wreq/pull/20.patch; sha256 = "1qfjwz5wlmmfcg8jy0yg7ixacq5fai3yscm552fba1ph66acyvg4"; })
  ];
})
