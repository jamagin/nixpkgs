# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, ansiTerminal, cmdargs, cpphs, extra, filepath
, haskellSrcExts, hscolour, transformers, uniplate
}:

cabal.mkDerivation (self: {
  pname = "hlint";
  version = "1.9.12";
  sha256 = "0ga66b7lpvgx2w1fg5gnilncg75dfxcjcrx9hvjyxh7fin4y1z6a";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal cmdargs cpphs extra filepath haskellSrcExts hscolour
    transformers uniplate
  ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/hlint/";
    description = "Source code suggestions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
