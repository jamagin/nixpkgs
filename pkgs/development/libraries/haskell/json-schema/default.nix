{ cabal, aeson, attoparsec, genericAeson, genericDeriving, HUnit
, tagged, tasty, tastyHunit, tastyTh, text, time
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "json-schema";
  version = "0.6";
  sha256 = "1rlx6r4ybbgz8q159mxh0hp3l0cc8q4nc1g7yd1ii1z4p9wjmnny";
  buildDepends = [
    aeson genericAeson genericDeriving tagged text time
    unorderedContainers vector
  ];
  testDepends = [
    aeson attoparsec genericAeson HUnit tagged tasty tastyHunit tastyTh
    text
  ];
  meta = {
    description = "Types and type classes for defining JSON schemas";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
