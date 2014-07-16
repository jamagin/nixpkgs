{ cabal, ekgCore, network, networkCarbon, text, time
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "ekg-carbon";
  version = "1.0.0";
  sha256 = "0zcnh74z0n0xxxr6r0j3kgpbfwli58y714k0mwwc2wxjgcv6xiyc";
  buildDepends = [
    ekgCore network networkCarbon text time unorderedContainers vector
  ];
  meta = {
    homepage = "http://github.com/ocharles/ekg-carbon";
    description = "An EKG backend to send statistics to Carbon (part of Graphite monitoring tools)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
