{ cabal, thLift }:

cabal.mkDerivation (self: {
  pname = "th-orphans";
  version = "0.8.1";
  sha256 = "1glf1zkiip18l0qdy3856ag7ksbxzd11dzdyq00qrz87kck5y58w";
  buildDepends = [ thLift ];
  jailbreak = true;
  meta = {
    description = "Orphan instances for TH datatypes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
