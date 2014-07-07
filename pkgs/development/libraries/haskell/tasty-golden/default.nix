{ cabal, async, deepseq, filepath, mtl, optparseApplicative, tagged
, tasty, tastyHunit, temporaryRc
}:

cabal.mkDerivation (self: {
  pname = "tasty-golden";
  version = "2.2.2.4";
  sha256 = "096c4h306r4z7wq8nm94mwmdndm0mwd6hhiqf77iilpdndasrl1c";
  buildDepends = [
    async deepseq filepath mtl optparseApplicative tagged tasty
    temporaryRc
  ];
  testDepends = [ filepath tasty tastyHunit temporaryRc ];
  meta = {
    homepage = "https://github.com/feuerbach/tasty-golden";
    description = "Golden tests support for tasty";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
