{ cabal, blazeHtml, dataDefault, mtl, syb, text, uniplate
, xssSanitize
}:

cabal.mkDerivation (self: {
  pname = "cheapskate";
  version = "0.1.0.1";
  sha256 = "0slrvbaamnwxx89kqjcr62058j00s2dw4c16q1swf817az2p66h8";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeHtml dataDefault mtl syb text uniplate xssSanitize
  ];
  meta = {
    homepage = "http://github.com/jgm/cheapskate";
    description = "Experimental markdown processor";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
