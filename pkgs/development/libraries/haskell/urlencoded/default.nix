{ cabal, mtl, network, split }:

cabal.mkDerivation (self: {
  pname = "urlencoded";
  version = "0.4.0";
  sha256 = "0idh70apfxx8bkbsxda4xhb0b5xf4x237dwi4v55ildrhxx4b68k";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl network split ];
  meta = {
    homepage = "https://github.com/pheaver/urlencoded";
    description = "Generate or process x-www-urlencoded data";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
