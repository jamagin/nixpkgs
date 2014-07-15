{ cabal, aeson, async, attoparsec, base64Bytestring, either
, monadLoops, mwcRandom, stm, text, transformers
, unorderedContainers, vector, websockets
}:

cabal.mkDerivation (self: {
  pname = "engine-io";
  version = "1.0.1";
  sha256 = "1wwh9p08dnjhixlli2wibqvwprz8cc5m0c4m17a4klcawr7kb3r6";
  buildDepends = [
    aeson async attoparsec base64Bytestring either monadLoops mwcRandom
    stm text transformers unorderedContainers vector websockets
  ];
  meta = {
    homepage = "http://github.com/ocharles/engine.io";
    description = "A Haskell implementation of Engine.IO";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
