# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, binary, deepseq, mtl, primitive, transformers, vector
, zlib
}:

cabal.mkDerivation (self: {
  pname = "JuicyPixels";
  version = "3.1.7.1";
  sha256 = "0mhsknqdrhxnm622mgrswvj4kvksh87x18s5ddgk4ylf0s2fjlap";
  buildDepends = [
    binary deepseq mtl primitive transformers vector zlib
  ];
  meta = {
    homepage = "https://github.com/Twinside/Juicy.Pixels";
    description = "Picture loading/serialization (in png, jpeg, bitmap, gif, tiff and radiance)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
