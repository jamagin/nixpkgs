# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, time }:

cabal.mkDerivation (self: {
  pname = "random";
  version = "1.0.1.3";
  sha256 = "06mbjx05c54iz5skn4biyjy9sqdr1qi6d33an8wya7sndnpakd21";
  buildDepends = [ time ];
  meta = {
    description = "random number library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
