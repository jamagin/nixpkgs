# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, attoparsec, base64Bytestring, cond, dataDefault
, directoryTree, exceptions, filepath, httpClient, httpTypes
, liftedBase, monadControl, mtl, network, networkUri, parallel
, scientific, temporary, text, time, transformers, transformersBase
, unorderedContainers, vector, zipArchive
}:

cabal.mkDerivation (self: {
  pname = "webdriver";
  version = "0.6.0.3";
  sha256 = "1q0l9rs5j4cxzyqsy6r40y425359s246spk3g3pks7s47yynjn4q";
  buildDepends = [
    aeson attoparsec base64Bytestring cond dataDefault directoryTree
    exceptions filepath httpClient httpTypes liftedBase monadControl
    mtl network networkUri scientific temporary text time transformers
    transformersBase unorderedContainers vector zipArchive
  ];
  testDepends = [ parallel text ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "https://github.com/kallisti-dev/hs-webdriver";
    description = "a Haskell client for the Selenium WebDriver protocol";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ aycanirican ];
  };
})
