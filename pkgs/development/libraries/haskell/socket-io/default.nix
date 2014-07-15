{ cabal, aeson, attoparsec, engineIo, mtl, stm, text, transformers
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "socket-io";
  version = "1.0.0";
  sha256 = "1xvj2x6nr14wna0plivzbzkca2y4xw6bxhvc5mqjh664197r9jsx";
  buildDepends = [
    aeson attoparsec engineIo mtl stm text transformers
    unorderedContainers vector
  ];
  meta = {
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
