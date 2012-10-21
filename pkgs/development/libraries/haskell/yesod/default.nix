{ cabal, attoparsec, blazeBuilder, blazeHtml, blazeMarkup, Cabal
, filepath, hamlet, httpTypes, monadControl, parsec, shakespeareCss
, shakespeareJs, shakespeareText, systemFileio, systemFilepath, tar
, text, time, transformers, unixCompat, unorderedContainers, wai
, waiExtra, warp, yaml, yesodAuth, yesodCore, yesodForm, yesodJson
, yesodPersistent, zlib
}:

cabal.mkDerivation (self: {
  pname = "yesod";
  version = "1.1.2";
  sha256 = "02d40crvsnhasa6jhl0k7hzxnwr9lxmbm7caf2mrvpr4sldzy1ss";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec blazeBuilder blazeHtml blazeMarkup Cabal filepath hamlet
    httpTypes monadControl parsec shakespeareCss shakespeareJs
    shakespeareText systemFileio systemFilepath tar text time
    transformers unixCompat unorderedContainers wai waiExtra warp yaml
    yesodAuth yesodCore yesodForm yesodJson yesodPersistent zlib
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Creation of type-safe, RESTful web applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
