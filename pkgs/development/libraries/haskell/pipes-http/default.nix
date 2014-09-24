# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, httpClient, httpClientTls, pipes }:

cabal.mkDerivation (self: {
  pname = "pipes-http";
  version = "1.0.1";
  sha256 = "15jmhf6lgqxv9zn08dky8biiv8cp4s3vf0xmp78pbllaqkvm4z9w";
  buildDepends = [ httpClient httpClientTls pipes ];
  jailbreak = true;
  meta = {
    description = "HTTP client with pipes interface";
    license = self.stdenv.lib.licenses.bsd3;
    maintainers = with self.stdenv.lib.maintainers; [ aycanirican ];
    platforms = self.ghc.meta.platforms;
  };
})
