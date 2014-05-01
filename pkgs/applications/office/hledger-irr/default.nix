{ cabal, Cabal, hledgerLib, statistics, time }:

cabal.mkDerivation (self: {
  pname = "hledger-irr";
  version = "0.1.1.4";
  sha256 = "0nqd8br86d71dpwq7p8956q74pgqdimid42xikp9zvf632x2s8ax";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Cabal hledgerLib statistics time ];
  meta = {
    description = "computes the internal rate of return of an investment";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
