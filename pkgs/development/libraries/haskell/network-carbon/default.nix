{ cabal, network, text, time, vector }:

cabal.mkDerivation (self: {
  pname = "network-carbon";
  version = "1.0.0";
  sha256 = "13mbwbcas7g8dyvlcbbl20ryzjvz0grmlbhb5kf1gs957kmn1z52";
  buildDepends = [ network text time vector ];
  meta = {
    homepage = "http://github.com/ocharles/network-carbon";
    description = "A Haskell implementation of the Carbon protocol (part of the Graphite monitoring tools)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
