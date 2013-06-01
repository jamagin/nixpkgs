{ cabal, conduit, HUnit, QuickCheck, resourcet, stm, stmChans
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
, transformers
}:

cabal.mkDerivation (self: {
  pname = "stm-conduit";
  version = "2.0.0";
  sha256 = "015gz4fqijgcs6dls5l8ry47q4a33a6ik0hsj5mw48iw44af39jr";
  buildDepends = [ conduit resourcet stm stmChans transformers ];
  testDepends = [
    conduit HUnit QuickCheck stm stmChans testFramework
    testFrameworkHunit testFrameworkQuickcheck2 transformers
  ];
  meta = {
    homepage = "https://github.com/wowus/stm-conduit";
    description = "Introduces conduits to channels, and promotes using conduits concurrently";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
