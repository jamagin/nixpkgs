# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, HUnit, nats, semigroupoids, semigroups, testFramework
, testFrameworkHunit, text, utf8String
}:

cabal.mkDerivation (self: {
  pname = "wl-pprint-extras";
  version = "3.5.0.3";
  sha256 = "124wb4hqd97f3naha0589v18lvi9xbn39bmn8jwaylvyg6s5fyyp";
  buildDepends = [ nats semigroupoids semigroups text utf8String ];
  testDepends = [ HUnit testFramework testFrameworkHunit ];
  meta = {
    homepage = "http://github.com/ekmett/wl-pprint-extras/";
    description = "A free monad based on the Wadler/Leijen pretty printer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
