{ cabal, filepath, parsec }:

cabal.mkDerivation (self: {
  pname = "csv";
  version = "0.1.2";
  sha256 = "00767ai09wm7f0yzmpqck3cpgxncpr9djnmmz5l17ajz69139x4c";
  buildDepends = [ filepath parsec ];
  meta = {
    description = "CSV loader and dumper";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
