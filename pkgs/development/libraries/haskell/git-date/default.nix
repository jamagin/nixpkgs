# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, QuickCheck, testFramework, testFrameworkQuickcheck2, time
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "git-date";
  version = "0.2.1";
  sha256 = "17xiim439igg1gfcfwpzxjkgpmfqqh9v79jm4bg0f9h5dijij79l";
  buildDepends = [ time utf8String ];
  testDepends = [
    QuickCheck testFramework testFrameworkQuickcheck2 time utf8String
  ];
  meta = {
    homepage = "https://github.com/singpolyma/git-date-haskell";
    description = "Bindings to the date parsing from Git";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
    hydraPlatforms = self.stdenv.lib.platforms.none;
    broken = true;
  };
})
