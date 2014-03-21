{ cabal }:

cabal.mkDerivation (self: {
  pname = "Boolean";
  version = "0.2.1";
  sha256 = "0vi09icwc254mbx85lf1n81mx4hr2sdf61a4njaqa91cf046sjlr";
  meta = {
    description = "Generalized booleans and numbers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
