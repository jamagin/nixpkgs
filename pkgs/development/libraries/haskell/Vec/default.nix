# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal }:

cabal.mkDerivation (self: {
  pname = "Vec";
  version = "1.0.5";
  sha256 = "0hyk553pdn72zc1i82njz3md8ycmzfiwi799y08qr3fg0i8r88zm";
  meta = {
    homepage = "http://github.net/sedillard/Vec";
    description = "Fixed-length lists and low-dimensional linear algebra";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
