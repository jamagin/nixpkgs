# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "monad-supply";
  version = "0.6";
  sha256 = "1gg4r7fwaq2fa0lz8pz301mk3q16xpbs7qv54hhggxrv3i1h33ir";
  buildDepends = [ mtl ];
  meta = {
    description = "Stateful supply monad";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
  };
})
