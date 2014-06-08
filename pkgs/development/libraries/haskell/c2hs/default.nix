{ cabal, filepath, HUnit, languageC, shelly, testFramework
, testFrameworkHunit, text, yaml
}:

cabal.mkDerivation (self: {
  pname = "c2hs";
  version = "0.17.2";
  sha256 = "1xrk0izdy5akjgmg9k4l9ccmmgv1avwh152pfpc1xm2rrwrg4bxk";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ filepath languageC ];
  testDepends = [
    filepath HUnit shelly testFramework testFrameworkHunit text yaml
  ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "https://github.com/haskell/c2hs";
    description = "C->Haskell FFI tool that gives some cross-language type safety";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
