# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, binary, ixShapable, syb }:

cabal.mkDerivation (self: {
  pname = "carray";
  version = "0.1.5.2";
  sha256 = "0kjqxjnamhnpjjf2bgm1gnsy6jx1fjbn5mx394pyx1vq3lkfgfb0";
  buildDepends = [ binary ixShapable syb ];
  meta = {
    description = "A C-compatible array library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
