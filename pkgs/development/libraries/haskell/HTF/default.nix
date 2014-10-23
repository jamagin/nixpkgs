# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, aesonPretty, base64Bytestring, cpphs, Diff
, filepath, haskellLexer, haskellSrc, HUnit, liftedBase
, monadControl, mtl, QuickCheck, random, regexCompat, temporary
, text, time, unorderedContainers, vector, xmlgen
}:

cabal.mkDerivation (self: {
  pname = "HTF";
  version = "0.12.2.2";
  sha256 = "02n3nqghcl9wmcr2iar9bg8nziddsvp43rzyasq4fnh166y87gc4";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson base64Bytestring cpphs Diff haskellLexer haskellSrc HUnit
    liftedBase monadControl mtl QuickCheck random regexCompat text time
    vector xmlgen
  ];
  testDepends = [
    aeson aesonPretty filepath HUnit mtl random regexCompat temporary
    text unorderedContainers
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/skogsbaer/HTF/";
    description = "The Haskell Test Framework";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
  };
})
