{ cabal }:

cabal.mkDerivation (self: {
  pname = "hinotify";
  version = "0.3.7";
  sha256 = "0i7mxg9ilzcgijda6j3ya5xnpbxa3wm9xswdfif95jim9w82sw0b";
  meta = {
    homepage = "https://github.com/kolmodin/hinotify.git";
    description = "Haskell binding to inotify";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
