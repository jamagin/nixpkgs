# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, extensibleExceptions, filepath, git, github, hslogger
, IfElse, MissingH, mtl, network, optparseApplicative, prettyShow
, text, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "github-backup";
  version = "1.20140707";
  sha256 = "0c15gq91c36xza7yiimqvgk609p9xf9jlzy9683d9p9bx1khpadd";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    extensibleExceptions filepath github hslogger IfElse MissingH mtl
    network optparseApplicative prettyShow text unixCompat
  ];
  buildTools = [ git ];
  meta = {
    homepage = "https://github.com/joeyh/github-backup";
    description = "backs up everything github knows about a repository, to the repository";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
