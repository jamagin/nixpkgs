{ cabal, aeson, blazeHtml, Cabal, codeBuilder, fclabels, filepath
, hashable, haskellSrcExts, hslogger, HStringTemplate, HUnit, hxt
, jsonSchema, restCore, safe, scientific, split, tagged
, testFramework, testFrameworkHunit, text, uniplate
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "rest-gen";
  version = "0.14.2";
  sha256 = "1hmf77hs3pp6lf4glh3lbbwfjr029js185v69bk8ycr1c4ib8nbp";
  buildDepends = [
    aeson blazeHtml Cabal codeBuilder fclabels filepath hashable
    haskellSrcExts hslogger HStringTemplate hxt jsonSchema restCore
    safe scientific split tagged text uniplate unorderedContainers
    vector
  ];
  testDepends = [
    haskellSrcExts HUnit restCore testFramework testFrameworkHunit
  ];
  meta = {
    description = "Documentation and client generation from rest definition";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
