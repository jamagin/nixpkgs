# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, async, attoparsec, base64Bytestring, blazeBuilder
, byteable, conduit, conduitExtra, cryptohash, cryptohashConduit
, cssText, dataDefault, fileEmbed, filepath, hashable, hjsmin
, hspec, httpTypes, HUnit, mimeTypes, resourcet, systemFileio
, systemFilepath, text, transformers, unixCompat
, unorderedContainers, wai, waiAppStatic, waiExtra, yesodCore
, yesodTest
}:

cabal.mkDerivation (self: {
  pname = "yesod-static";
  version = "1.4.0.3";
  sha256 = "15rwlw76rfh18l3ap73aqmwz4bafmxbr5pchyarll14ps0rjs74g";
  buildDepends = [
    async attoparsec base64Bytestring blazeBuilder byteable conduit
    conduitExtra cryptohash cryptohashConduit cssText dataDefault
    fileEmbed filepath hashable hjsmin httpTypes mimeTypes resourcet
    systemFileio systemFilepath text transformers unixCompat
    unorderedContainers wai waiAppStatic yesodCore
  ];
  testDepends = [
    async base64Bytestring byteable conduit conduitExtra cryptohash
    cryptohashConduit dataDefault fileEmbed filepath hjsmin hspec
    httpTypes HUnit mimeTypes resourcet systemFileio systemFilepath
    text transformers unixCompat unorderedContainers wai waiAppStatic
    waiExtra yesodCore yesodTest
  ];
  doCheck = false;
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Static file serving subsite for Yesod Web Framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
