# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, base64Bytestring, blazeHtml, extensibleExceptions
, filepath, hslogger, html, HUnit, monadControl, mtl, network
, networkUri, parsec, sendfile, syb, systemFilepath, text, threads
, time, timeCompat, transformers, transformersBase, utf8String
, xhtml, zlib
}:

cabal.mkDerivation (self: {
  pname = "happstack-server";
  version = "7.3.9";
  sha256 = "10js2kmxw5lyy1h5xyz7qx852d29cl48qxyvadc4bdad6w06gdlz";
  buildDepends = [
    base64Bytestring blazeHtml extensibleExceptions filepath hslogger
    html monadControl mtl network networkUri parsec sendfile syb
    systemFilepath text threads time timeCompat transformers
    transformersBase utf8String xhtml zlib
  ];
  testDepends = [ HUnit parsec zlib ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "http://happstack.com";
    description = "Web related tools and services";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
