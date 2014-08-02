# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, enumset, eventList, explicitException, jack2, midi
, nonNegative, transformers
}:

cabal.mkDerivation (self: {
  pname = "jack";
  version = "0.7.0.3";
  sha256 = "12ap7xcgzmp5zwmqkwsgxplh5li21m7xngijr4mhnn9y33xc1lrk";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    enumset eventList explicitException midi nonNegative transformers
  ];
  pkgconfigDepends = [ jack2 ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/JACK";
    description = "Bindings for the JACK Audio Connection Kit";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ertes ];
  };
})
