{ cabal, entropy }:

cabal.mkDerivation (self: {
  pname = "crypto-random-api";
  version = "0.2.0";
  sha256 = "0z49kwgjj7rz235642q64hbkgp0zl6ipn29xd19yb75xc5q7gsan";
  buildDepends = [ entropy ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-random-api";
    description = "Simple random generators API for cryptography related code";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
