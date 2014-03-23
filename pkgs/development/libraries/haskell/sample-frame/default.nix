{ cabal, QuickCheck, storableRecord }:

cabal.mkDerivation (self: {
  pname = "sample-frame";
  version = "0.0.3";
  sha256 = "0ivj0bcnqqc805np62bdpvh8v4ykmw86ph5rp7k54bbv9wd31bsv";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ QuickCheck storableRecord ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Synthesizer";
    description = "Handling of samples in an (audio) signal";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
