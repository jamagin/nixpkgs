{ cabal, happstackServer, mtl, restCore, restGen, utf8String }:

cabal.mkDerivation (self: {
  pname = "rest-happstack";
  version = "0.2.10";
  sha256 = "1np8y0v6jnk2lw0aqlzb9dn1vlk8cg75xrhkjmm6qh0z90fy3p6z";
  buildDepends = [ happstackServer mtl restCore restGen utf8String ];
  meta = {
    description = "Rest driver for Happstack";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
