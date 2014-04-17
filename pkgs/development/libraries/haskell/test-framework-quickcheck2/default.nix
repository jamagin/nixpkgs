{ cabal, extensibleExceptions, QuickCheck, random, testFramework }:

cabal.mkDerivation (self: {
  pname = "test-framework-quickcheck2";
  version = "0.3.0.3";
  sha256 = "12p1zwrsz35r3j5gzbvixz9z1h5643rhihf5gqznmc991krwd5nc";
  buildDepends = [
    extensibleExceptions QuickCheck random testFramework
  ];
  jailbreak = true;
  meta = {
    homepage = "https://batterseapower.github.io/test-framework/";
    description = "QuickCheck2 support for the test-framework package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
