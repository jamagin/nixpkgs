# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, authenticate, base16Bytestring, base64Bytestring
, binary, blazeBuilder, blazeHtml, blazeMarkup, byteable, conduit
, conduitExtra, cryptohash, dataDefault, emailValidate, fileEmbed
, httpClient, httpConduit, httpTypes, liftedBase, mimeMail
, networkUri, persistent, persistentTemplate, random, resourcet
, safe, shakespeare, text, time, transformers, unorderedContainers
, wai, yesodCore, yesodForm, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "1.4.0.1";
  sha256 = "1d5rimp6jnxi8j518g3hg74a4g90rvgfhnxpz2kj6881v85avvh3";
  buildDepends = [
    aeson authenticate base16Bytestring base64Bytestring binary
    blazeBuilder blazeHtml blazeMarkup byteable conduit conduitExtra
    cryptohash dataDefault emailValidate fileEmbed httpClient
    httpConduit httpTypes liftedBase mimeMail networkUri persistent
    persistentTemplate random resourcet safe shakespeare text time
    transformers unorderedContainers wai yesodCore yesodForm
    yesodPersistent
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Authentication for Yesod";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
