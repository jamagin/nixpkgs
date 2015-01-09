{ pkgs }:

with import ./lib.nix;

self: super: {

  # Disable GHC 7.9.x core libraries.
  array = null;
  base = null;
  binary = null;
  bin-package-db = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
  filepath = null;
  ghc-prim = null;
  haskeline = null;
  hoopl = null;
  hpc = null;
  integer-gmp = null;
  pretty = null;
  process = null;
  rts = null;
  template-haskell = null;
  terminfo = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # We cannot build jailbreak without Cabal 1.20.x, and we cannot build
  # Cabal 1.20.x without jailbreak. Go figure. Let's use a sledgehammer.
  jailbreak-cabal = pkgs.haskellngPackages.jailbreak-cabal;

  # haddock: internal error: expectJust getPackageDetails
  mkDerivation = drv: super.mkDerivation (drv // { noHaddock = true; });

  # These used to be a core packages in GHC 7.8.x.
  old-locale = self.old-locale_1_0_0_7;
  old-time = self.old-time_1_1_0_3;

  # We have transformers 4.x
  mtl = self.mtl_2_2_1;
  transformers-compat = overrideCabal super.transformers-compat (drv: {
    configureFlags = [];
  });

  # Setup: At least the following dependencies are missing: base <4.8
  hspec-expectations = overrideCabal super.hspec-expectations (drv: {
    patchPhase = "sed -i -e 's|base < 4.8|base|' hspec-expectations.cabal";
  });
  utf8-string = overrideCabal super.utf8-string (drv: {
    patchPhase = "sed -i -e 's|base >= 3 && < 4.8|base|' utf8-string.cabal";
  });

}
