# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal }:

cabal.mkDerivation (self: {
  pname = "monomorphic";
  version = "0.0.3.2";
  sha256 = "13zw506wifz2lf7n4a48rkn7ym44jpiqag21zc1py6xxdlkbrhh2";
  meta = {
    homepage = "https://github.com/konn/monomorphic";
    description = "Library to convert polymorphic datatypes to/from its monomorphic represetation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ fuuzetsu ];
  };
})
