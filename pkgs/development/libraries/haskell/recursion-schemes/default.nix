{ cabal, comonad, free, transformers }:

cabal.mkDerivation (self: {
  pname = "recursion-schemes";
  version = "4.1";
  sha256 = "03rf65ak6bxsr204j6d8g5zyxva9vbmncycav3smqwfg5n3b3pwf";
  buildDepends = [ comonad free transformers ];
  meta = {
    homepage = "http://github.com/ekmett/recursion-schemes/";
    description = "Generalized bananas, lenses and barbed wire";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
