{ cabal }:

cabal.mkDerivation (self: {
  pname = "snap-loader-static";
  version = "0.9.0.2";
  sha256 = "0d6s7n6yryfs2jkw0hxvhvc79fhbj256askb1c6ksqhscxxxwz1m";
  meta = {
    homepage = "http://snapframework.com/";
    description = "Snap: A Haskell Web Framework: static loader";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
