{ cabal, attoparsec, base16Bytestring, ioStreams, pdfToolboxCore
, text
}:

cabal.mkDerivation (self: {
  pname = "pdf-toolbox-content";
  version = "0.0.3.0";
  sha256 = "0glcm6mrgg8ixzhp09kfkk3ra3qblvrp1wcsa2nhqlypg3ca8r3h";
  buildDepends = [
    attoparsec base16Bytestring ioStreams pdfToolboxCore text
  ];
  meta = {
    description = "A collection of tools for processing PDF files";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ ianwookim ];
  };
})
