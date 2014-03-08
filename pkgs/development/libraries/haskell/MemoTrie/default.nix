{ cabal, void }:

cabal.mkDerivation (self: {
  pname = "MemoTrie";
  version = "0.6.2";
  sha256 = "1g4b82s30bqkfids3iywf873nyn8h7l8rp8l3xl58smj5lbi3p4x";
  buildDepends = [ void ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/MemoTrie";
    description = "Trie-based memo functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
