{ cabal }:

cabal.mkDerivation (self: {
  pname = "string-qq";
  version = "0.0.2";
  sha256 = "0662m3i5xrdrr95w829bszkhp88mj9iy1zya54vk2sl5hz9wlmwp";
  meta = {
    description = "QuasiQuoter for non-interpolated strings, texts and bytestrings";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
  };
})
