# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, mtl, random, transformers }:

cabal.mkDerivation (self: {
  pname = "MonadRandom";
  version = "0.1.13";
  sha256 = "1pi12ymsbl2l0ly3ggihg8r0ac87ax267m419cga60wp5ry5zbnk";
  buildDepends = [ mtl random transformers ];
  meta = {
    description = "Random-number generation monad";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    hydraPlatforms = self.stdenv.lib.platforms.none;
  };
})
