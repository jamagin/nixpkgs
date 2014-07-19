# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, attoparsec, Cabal, deepseq, filepath, mtl
, profunctors, QuickCheck, random, systemPosixRedirect, text, time
, vector, vectorSpace, vectorThUnbox
}:

cabal.mkDerivation (self: {
  pname = "thyme";
  version = "0.3.5.2";
  sha256 = "1vb5qn9m88y9738d9znim5lprb8z10am5yjaksdjl151li8apd6x";
  buildDepends = [
    aeson attoparsec deepseq mtl profunctors QuickCheck random text
    time vector vectorSpace vectorThUnbox
  ];
  testDepends = [
    attoparsec Cabal filepath mtl profunctors QuickCheck random
    systemPosixRedirect text time vectorSpace
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/liyang/thyme";
    description = "A faster time library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
