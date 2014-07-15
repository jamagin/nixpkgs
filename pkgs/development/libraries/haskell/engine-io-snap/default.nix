{ cabal, attoparsecEnumerator, engineIo, snapCore
, unorderedContainers, websockets, websocketsSnap
}:

cabal.mkDerivation (self: {
  pname = "engine-io-snap";
  version = "1.0.0";
  sha256 = "152hz2b9zbmjpp517g6kp7fs7kbvyil28dp6djqjlmp9fqkgckap";
  buildDepends = [
    attoparsecEnumerator engineIo snapCore unorderedContainers
    websockets websocketsSnap
  ];
  meta = {
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
