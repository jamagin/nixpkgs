{ cabal, blazeBuilder, filepath, HUnit, hxt, mtl, QuickCheck, text
}:

cabal.mkDerivation (self: {
  pname = "xmlgen";
  version = "0.6.2.1";
  sha256 = "1rmsg9wxs0bsj0xpagxrm3fmlqd63b0dfyc21rx9jj76g9za29wh";
  buildDepends = [ blazeBuilder mtl text ];
  testDepends = [ filepath HUnit hxt QuickCheck text ];
  doCheck = false;
  meta = {
    description = "Fast XML generation library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
