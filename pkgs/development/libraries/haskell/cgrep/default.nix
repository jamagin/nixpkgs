{ cabal, ansiTerminal, cmdargs, dlist, filepath, regexPosix, safe
, split, stm, stringsearch, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "cgrep";
  version = "6.4.3.1";
  sha256 = "0pqifapjgazz7wiydc775i4f6iixq8v87rzjgvvymdbdsn0sfa0r";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    ansiTerminal cmdargs dlist filepath regexPosix safe split stm
    stringsearch unorderedContainers
  ];
  meta = {
    homepage = "http://awgn.github.io/cgrep/";
    description = "Command line tool";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
  };
})
