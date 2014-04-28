{ cabal, binary }:

cabal.mkDerivation (self: {
  pname = "pointedlist";
  version = "0.6.1";
  sha256 = "16xsrzqql7i4z6a3xy07sqnbyqdmcar1jiacla58y4mvkkwb0g3l";
  buildDepends = [ binary ];
  meta = {
    description = "A zipper-like comonad which works as a list, tracking a position";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
