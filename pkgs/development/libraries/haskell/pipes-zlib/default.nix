# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, pipes, transformers, zlib, zlibBindings }:

cabal.mkDerivation (self: {
  pname = "pipes-zlib";
  version = "0.4.1";
  sha256 = "0wjx51d3inhsjzqf16l46mhh0mdsa8fk7x1vvp2apg9s6zfw624k";
  buildDepends = [ pipes transformers zlib zlibBindings ];
  meta = {
    homepage = "https://github.com/k0001/pipes-zlib";
    description = "Zlib and GZip compression and decompression for Pipes streams";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ ocharles ];
  };
})
