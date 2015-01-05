# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, blazeHtml, blazeMarkup, shakespeare, text, time
, xmlConduit, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-newsfeed";
  version = "1.4.0.1";
  sha256 = "02ydkri23vrm7mak2b1ybfhkdgc2dmv9vq3ki2d7sd005sp3zdly";
  buildDepends = [
    blazeHtml blazeMarkup shakespeare text time xmlConduit yesodCore
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Helper functions and data types for producing News feeds";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
