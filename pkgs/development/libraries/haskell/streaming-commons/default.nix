# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, async, blazeBuilder, deepseq, hspec, network, QuickCheck
, random, stm, text, transformers, zlib
}:

cabal.mkDerivation (self: {
  pname = "streaming-commons";
  version = "0.1.7.3";
  sha256 = "12sm59dhjrygly215888i2xcsn5m5a393ir0mm6w62883x49wzxb";
  buildDepends = [
    blazeBuilder network random stm text transformers zlib
  ];
  testDepends = [
    async blazeBuilder deepseq hspec network QuickCheck text zlib
  ];
  meta = {
    homepage = "https://github.com/fpco/streaming-commons";
    description = "Common lower-level functions needed by various streaming data libraries";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
