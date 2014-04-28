{ cabal, shakespeare }:

cabal.mkDerivation (self: {
  pname = "shakespeare-text";
  version = "1.1.0";
  sha256 = "18ixixb9aqn630s9wblxcki1gggm4i0fj9752c55p3b42q8h86rc";
  buildDepends = [ shakespeare ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "Interpolation with quasi-quotation: put variables strings (deprecated)";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
