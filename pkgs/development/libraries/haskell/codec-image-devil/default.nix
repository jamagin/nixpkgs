{ cabal, libdevil }:

cabal.mkDerivation (self: {
  pname = "Codec-Image-DevIL";
  version = "0.2.3";
  sha256 = "1kv3hns9f0bhfb723nj9szyz3zfqpvy02azzsiymzjz4ajhqmrsz";
  extraLibraries = [ libdevil ];
  meta = {
    description = "An FFI interface to the DevIL library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
