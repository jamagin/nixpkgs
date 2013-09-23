{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "tagsoup";
  version = "0.13";
  sha256 = "1pfkcfrmhzxplfkdzb0zj24dfsddw91plqp3mg2gqkv82y8blzk1";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ text ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/tagsoup/";
    description = "Parsing and extracting information from (possibly malformed) HTML/XML documents";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
