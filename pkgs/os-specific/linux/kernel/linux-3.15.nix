{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.15.7";
  extraMeta.branch = "3.15";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "034q34gib9jqfiydnqf5i827ns07apmkh2j48vbakdwydvzzv6fj";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
