# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, blazeHtml, Diff, filepath, mtl, parsec, regexPcre
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "highlighting-kate";
  version = "0.5.11";
  sha256 = "0jfgz4cyn6fylfrsk1yi0fykir8mhxdniq80h7hy5i2xv7qwf5vw";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeHtml filepath mtl parsec regexPcre utf8String
  ];
  testDepends = [ blazeHtml Diff filepath ];
  prePatch = "sed -i -e 's|regex-pcre-builtin >= .*|regex-pcre|' highlighting-kate.cabal";
  meta = {
    homepage = "http://github.com/jgm/highlighting-kate";
    description = "Syntax highlighting";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
