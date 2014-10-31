# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, filepath, QuickCheck, time }:

cabal.mkDerivation (self: {
  pname = "extra";
  version = "0.5.1";
  sha256 = "0ac271lsqkgi0rrnhgzh1hjghz8vi6fj4snc8j8zrjgghc30y9wk";
  buildDepends = [ filepath time ];
  testDepends = [ filepath QuickCheck time ];
  meta = {
    homepage = "https://github.com/ndmitchell/extra#readme";
    description = "Extra functions I use";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ aycanirican ];
  };
})
