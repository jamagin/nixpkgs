# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, ansiWlPprint, Cabal, filepath, mtl, optparseApplicative
, tar, utf8String
}:

cabal.mkDerivation (self: {
  pname = "cabal-db";
  version = "0.1.10";
  sha256 = "0j9xnf23zrpyrfkcx321rqbabzsm4208idpvfy7sdnnvw9a2k5xw";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    ansiWlPprint Cabal filepath mtl optparseApplicative tar utf8String
  ];
  meta = {
    homepage = "http://github.com/vincenthz/cabal-db";
    description = "query tools for the local cabal database";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
