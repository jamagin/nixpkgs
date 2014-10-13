# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, asn1Encoding, asn1Parse, asn1Types, cryptohash
, cryptoPubkeyTypes, filepath, HUnit, mtl, pem, QuickCheck
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, time
}:

cabal.mkDerivation (self: {
  pname = "x509";
  version = "1.4.13";
  sha256 = "1cl2ygk38jh803aplsg68q6njzb0wcd1syb182amxqn8jlwh8a7c";
  buildDepends = [
    asn1Encoding asn1Parse asn1Types cryptohash cryptoPubkeyTypes
    filepath mtl pem time
  ];
  testDepends = [
    asn1Types cryptoPubkeyTypes HUnit mtl QuickCheck testFramework
    testFrameworkHunit testFrameworkQuickcheck2 time
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-certificate";
    description = "X509 reader and writer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
