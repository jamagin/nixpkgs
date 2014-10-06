# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, filepath, tasty }:

cabal.mkDerivation (self: {
  pname = "tasty-program";
  version = "1.0.1";
  sha256 = "04q2pp7hwqiiry17dd3ng0i6ikqzpg7hfgf0ckcg33xw450kpx9n";
  buildDepends = [ filepath tasty ];
  meta = {
    homepage = "https://github.com/jstolarek/tasty-program";
    description = "Use tasty framework to test whether a program executes correctly";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
