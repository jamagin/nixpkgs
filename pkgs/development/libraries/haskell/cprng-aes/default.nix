# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, byteable, cipherAes, cryptoRandom }:

cabal.mkDerivation (self: {
  pname = "cprng-aes";
  version = "0.6.1";
  sha256 = "1wr15kbmk1g3l8a75n0iwbzqg24ixv78slwzwb2q6rlcvq0jlnb4";
  buildDepends = [ byteable cipherAes cryptoRandom ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cprng-aes";
    description = "Crypto Pseudo Random Number Generator using AES in counter mode";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
