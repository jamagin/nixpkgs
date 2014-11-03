# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, binary, fastLogger, hspec, liftedBase, monadControl
, monadLogger, pcreLight, text, time, transformers, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "logging";
  version = "2.1.0";
  sha256 = "15ad4g7zkbklawd98m6x838fr5383vkvq92y75f56j1kj17g7rrh";
  buildDepends = [
    binary fastLogger liftedBase monadControl monadLogger pcreLight
    text time transformers vectorSpace
  ];
  testDepends = [ hspec monadLogger ];
  meta = {
    description = "Simplified logging in IO for application writers";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
