{ cabal }:

cabal.mkDerivation (self: {
  pname = "list-extras";
  version = "0.4.1.3";
  sha256 = "16w10xgh2y76q8aj5pgw4zq5p2phjzf5g1bmkacrm8gbwkp4v71s";
  meta = {
    homepage = "http://code.haskell.org/~wren/";
    description = "Common not-so-common functions for lists";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
