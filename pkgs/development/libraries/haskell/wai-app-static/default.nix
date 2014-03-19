{ cabal, base64Bytestring, blazeBuilder, blazeHtml, blazeMarkup
, byteable, cryptohash, cryptohashConduit, fileEmbed, filepath
, hspec, httpDate, httpTypes, mimeTypes, network, systemFileio
, systemFilepath, text, time, transformers, unixCompat
, unorderedContainers, wai, waiTest, zlib
}:

cabal.mkDerivation (self: {
  pname = "wai-app-static";
  version = "2.0.0.4";
  sha256 = "1dk1s2q8w2rvknknw54ja2jhm1nayp8zpyis1zhgnl4yjgwr5kld";
  buildDepends = [
    base64Bytestring blazeBuilder blazeHtml blazeMarkup byteable
    cryptohash cryptohashConduit fileEmbed filepath httpDate httpTypes
    mimeTypes systemFileio systemFilepath text time transformers
    unixCompat unorderedContainers wai zlib
  ];
  testDepends = [
    hspec httpDate httpTypes mimeTypes network text time transformers
    unixCompat wai waiTest zlib
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/web-application-interface";
    description = "WAI application for static serving";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
