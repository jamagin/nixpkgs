{ cabal, aeson, attoparsec, blazeBuilder, blazeHtml, blazeMarkup
, cryptoApi, dataDefault, emailValidate, hamlet, hspec, network
, persistent, resourcet, shakespeareCss, shakespeareJs, text, time
, transformers, wai, xssSanitize, yesodCore, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-form";
  version = "1.3.5.2";
  sha256 = "0ppzj04c5y02k2daw52g2pkzf85mhsg7n4hbkm05xk1crzbrbcxj";
  buildDepends = [
    aeson attoparsec blazeBuilder blazeHtml blazeMarkup cryptoApi
    dataDefault emailValidate hamlet network persistent resourcet
    shakespeareCss shakespeareJs text time transformers wai xssSanitize
    yesodCore yesodPersistent
  ];
  testDepends = [ hspec text time ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Form handling support for Yesod Web Framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
