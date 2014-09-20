# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, blazeBuilder, enumerator, ioStreams, mtl, snapCore
, snapServer, websockets
}:

cabal.mkDerivation (self: {
  pname = "websockets-snap";
  version = "0.8.2.2";
  sha256 = "1r5y5czpxrc06i7w3y3fa4dlqmxdypcc8yplg28cv4k3mkfa1hf4";
  buildDepends = [
    blazeBuilder enumerator ioStreams mtl snapCore snapServer
    websockets
  ];
  jailbreak = true;
  meta = {
    description = "Snap integration for the websockets library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ ocharles ];
  };
})
