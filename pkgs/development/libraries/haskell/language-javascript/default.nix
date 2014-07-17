# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, alex, blazeBuilder, Cabal, happy, HUnit, mtl, QuickCheck
, testFramework, testFrameworkHunit, utf8Light, utf8String
}:

cabal.mkDerivation (self: {
  pname = "language-javascript";
  version = "0.5.13";
  sha256 = "0h46wfh5xi3gbiaplx3ikmj7mfcwm1d37i5c9n3qfsmmkac29n2w";
  buildDepends = [ blazeBuilder mtl utf8String ];
  testDepends = [
    blazeBuilder Cabal HUnit mtl QuickCheck testFramework
    testFrameworkHunit utf8Light utf8String
  ];
  buildTools = [ alex happy ];
  meta = {
    homepage = "http://github.com/alanz/language-javascript";
    description = "Parser for JavaScript";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
