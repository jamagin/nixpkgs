# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, hspec }:

cabal.mkDerivation (self: {
  pname = "auto-update";
  version = "0.1.1.2";
  sha256 = "0901zqky70wyxl17vwz6smhnpsfjnsk0f2xqiyz902vl7apx66c6";
  testDepends = [ hspec ];
  meta = {
    homepage = "https://github.com/yesodweb/wai";
    description = "Efficiently run periodic, on-demand actions";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
