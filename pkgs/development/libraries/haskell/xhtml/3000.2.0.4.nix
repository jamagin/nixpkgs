{ cabal }:

cabal.mkDerivation (self: {
  pname = "xhtml";
  version = "3000.2.0.4";
  sha256 = "07kqii5dsfdaf46y4k19l9llhzhxssr24jbjpr5i8p1qh7117abw";
  meta = {
    homepage = "https://github.com/haskell/xhtml";
    description = "An XHTML combinator library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
