{ cabal, lochTh, placeholders }:

cabal.mkDerivation (self: {
  pname = "focus";
  version = "0.1.1";
  sha256 = "0x158zqxgm8ys4mxs94zl811qfdcb06jqy5h99qc63r7snwnixmd";
  buildDepends = [ lochTh placeholders ];
  meta = {
    homepage = "https://github.com/nikita-volkov/focus";
    description = "A general abstraction for manipulating elements of container data structures";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
