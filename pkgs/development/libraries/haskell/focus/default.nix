# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal }:

cabal.mkDerivation (self: {
  pname = "focus";
  version = "0.1.3";
  sha256 = "11l6rlr22m0z41c9fynpisj0cnx70zzcxhsakz9b09ap8wj0raqy";
  meta = {
    homepage = "https://github.com/nikita-volkov/focus";
    description = "A general abstraction for manipulating elements of container data structures";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
