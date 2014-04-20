{ cabal, httpClient }:

cabal.mkDerivation (self: {
  pname = "http-client-conduit";
  version = "0.3.0";
  sha256 = "0k2vq9y7kfbkhcsszjr74ahq5nw5z7dbzjhw1ixbigcr56axsd19";
  buildDepends = [ httpClient ];
  noHaddock = true;
  meta = {
    homepage = "https://github.com/snoyberg/http-client";
    description = "Frontend support for using http-client with conduit (deprecated)";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
