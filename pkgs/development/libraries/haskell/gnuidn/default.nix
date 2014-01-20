{ cabal, c2hs, libidn, text }:

cabal.mkDerivation (self: {
  pname = "gnuidn";
  version = "0.2.1";
  sha256 = "1jii635wc3j1jnwwx24j9gg9xd91g2iw5967acn74p7db62lqx37";
  buildDepends = [ text ];
  buildTools = [ c2hs ];
  extraLibraries = [ libidn ];
  pkgconfigDepends = [ libidn ];
  meta = {
    homepage = "https://john-millikin.com/software/haskell-gnuidn/";
    description = "Bindings for GNU IDN";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
  };
})
