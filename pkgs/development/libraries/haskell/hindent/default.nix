# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, dataDefault, haskellSrcExts, hspec, monadLoops, mtl, text
}:

cabal.mkDerivation (self: {
  pname = "hindent";
  version = "3.9.1";
  sha256 = "1q1a5smykjs36y29cn34kws443kw0w26xjjfdvv0kf69jpcm4b2f";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ dataDefault haskellSrcExts monadLoops mtl text ];
  testDepends = [
    dataDefault haskellSrcExts hspec monadLoops mtl text
  ];
  doCheck = false;
  meta = {
    description = "Extensible Haskell pretty printer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
