let lib = import ../../../lib; in lib.makeOverridable (

{ name ? "stdenv", preHook ? "", initialPath, cc, shell
, allowedRequisites ? null, extraAttrs ? {}, overrides ? (self: super: {}), config

, # The `fetchurl' to use for downloading curl and its dependencies
  # (see all-packages.nix).
  fetchurlBoot

, setupScript ? ./setup.sh

, extraBuildInputs ? []
, __stdenvImpureHostDeps ? []
, __extraImpureHostDeps ? []
, stdenvSandboxProfile ? ""
, extraSandboxProfile ? ""

, # The platforms here do *not* correspond to the stage the stdenv is
  # used in, but rather the previous one, in which it was built. We
  # use the latter two platforms, like a cross compiler, because the
  # stand environment is a build tool if you squint at it, and because
  # neither of these are used when building stdenv so we know the
  # build platform is irrelevant.
  hostPlatform, targetPlatform
}:

let
  inherit (targetPlatform) system;

  # See discussion at https://github.com/NixOS/nixpkgs/pull/25304#issuecomment-298385426
  # for why this defaults to false, but I (@copumpkin) want to default it to true soon.
  shouldCheckMeta = config.checkMeta or false;

  allowUnfree = config.allowUnfree or false || builtins.getEnv "NIXPKGS_ALLOW_UNFREE" == "1";

  whitelist = config.whitelistedLicenses or [];
  blacklist = config.blacklistedLicenses or [];

  ifDarwin = attrs: if system == "x86_64-darwin" then attrs else {};

  onlyLicenses = list:
    lib.lists.all (license:
      let l = lib.licenses.${license.shortName or "BROKEN"} or false; in
      if license == l then true else
        throw ''‘${showLicense license}’ is not an attribute of lib.licenses''
    ) list;

  areLicenseListsValid =
    if lib.mutuallyExclusive whitelist blacklist then
      assert onlyLicenses whitelist; assert onlyLicenses blacklist; true
    else
      throw "whitelistedLicenses and blacklistedLicenses are not mutually exclusive.";

  hasLicense = attrs:
    attrs ? meta.license;

  hasWhitelistedLicense = assert areLicenseListsValid; attrs:
    hasLicense attrs && builtins.elem attrs.meta.license whitelist;

  hasBlacklistedLicense = assert areLicenseListsValid; attrs:
    hasLicense attrs && builtins.elem attrs.meta.license blacklist;

  allowBroken = config.allowBroken or false || builtins.getEnv "NIXPKGS_ALLOW_BROKEN" == "1";

  isUnfree = licenses: lib.lists.any (l:
    !l.free or true || l == "unfree" || l == "unfree-redistributable") licenses;

  # Alow granular checks to allow only some unfree packages
  # Example:
  # {pkgs, ...}:
  # {
  #   allowUnfree = false;
  #   allowUnfreePredicate = (x: pkgs.lib.hasPrefix "flashplayer-" x.name);
  # }
  allowUnfreePredicate = config.allowUnfreePredicate or (x: false);

  # Check whether unfree packages are allowed and if not, whether the
  # package has an unfree license and is not explicitely allowed by the
  # `allowUNfreePredicate` function.
  hasDeniedUnfreeLicense = attrs:
    !allowUnfree &&
    hasLicense attrs &&
    isUnfree (lib.lists.toList attrs.meta.license) &&
    !allowUnfreePredicate attrs;

  allowInsecureDefaultPredicate = x: builtins.elem x.name (config.permittedInsecurePackages or []);
  allowInsecurePredicate = x: (config.allowUnfreePredicate or allowInsecureDefaultPredicate) x;

  hasAllowedInsecure = attrs:
    (attrs.meta.knownVulnerabilities or []) == [] ||
    allowInsecurePredicate attrs ||
    builtins.getEnv "NIXPKGS_ALLOW_INSECURE" == "1";

  showLicense = license: license.shortName or "unknown";

  defaultNativeBuildInputs = extraBuildInputs ++
    [ ../../build-support/setup-hooks/move-docs.sh
      ../../build-support/setup-hooks/compress-man-pages.sh
      ../../build-support/setup-hooks/strip.sh
      ../../build-support/setup-hooks/patch-shebangs.sh
    ]
      # FIXME this on Darwin; see
      # https://github.com/NixOS/nixpkgs/commit/94d164dd7#commitcomment-22030369
    ++ lib.optional result.isLinux ../../build-support/setup-hooks/audit-tmpdir.sh
    ++ [
      ../../build-support/setup-hooks/multiple-outputs.sh
      ../../build-support/setup-hooks/move-sbin.sh
      ../../build-support/setup-hooks/move-lib64.sh
      ../../build-support/setup-hooks/set-source-date-epoch-to-latest.sh
      cc
    ];

  # `mkDerivation` wraps the builtin `derivation` function to
  # produce derivations that use this stdenv and its shell.
  #
  # See also:
  #
  # * https://nixos.org/nixpkgs/manual/#sec-using-stdenv
  #   Details on how to use this mkDerivation function
  #
  # * https://nixos.org/nix/manual/#ssec-derivation
  #   Explanation about derivations in general
  mkDerivation =
    { nativeBuildInputs ? []
    , buildInputs ? []

    , propagatedNativeBuildInputs ? []
    , propagatedBuildInputs ? []

    , crossConfig ? null
    , meta ? {}
    , passthru ? {}
    , pos ? # position used in error messages and for meta.position
        (if attrs.meta.description or null != null
          then builtins.unsafeGetAttrPos "description" attrs.meta
          else builtins.unsafeGetAttrPos "name" attrs)
    , separateDebugInfo ? false
    , outputs ? [ "out" ]
    , __impureHostDeps ? []
    , __propagatedImpureHostDeps ? []
    , sandboxProfile ? ""
    , propagatedSandboxProfile ? ""
    , ... } @ attrs:
    let
      dependencies = [
        (map (drv: drv.nativeDrv or drv) nativeBuildInputs)
        (map (drv: drv.crossDrv or drv) buildInputs)
      ];
      propagatedDependencies = [
        (map (drv: drv.nativeDrv or drv) propagatedNativeBuildInputs)
        (map (drv: drv.crossDrv or drv) propagatedBuildInputs)
      ];
    in let
      pos_str = if pos != null then "‘" + pos.file + ":" + toString pos.line + "’" else "«unknown-file»";

      remediation = {
        unfree = remediate_whitelist "Unfree";
        broken = remediate_whitelist "Broken";
        blacklisted = x: "";
        insecure = remediate_insecure;
        unknown-meta = x: "";
      };
      remediate_whitelist = allow_attr: attrs:
        ''
          a) For `nixos-rebuild` you can set
            { nixpkgs.config.allow${allow_attr} = true; }
          in configuration.nix to override this.

          b) For `nix-env`, `nix-build`, `nix-shell` or any other Nix command you can add
            { allow${allow_attr} = true; }
          to ~/.config/nixpkgs/config.nix.
        '';

      remediate_insecure = attrs:
        ''

          Known issues:

        '' + (lib.fold (issue: default: "${default} - ${issue}\n") "" attrs.meta.knownVulnerabilities) + ''

          You can install it anyway by whitelisting this package, using the
          following methods:

          a) for `nixos-rebuild` you can add ‘${attrs.name or "«name-missing»"}’ to
             `nixpkgs.config.permittedInsecurePackages` in the configuration.nix,
             like so:

               {
                 nixpkgs.config.permittedInsecurePackages = [
                   "${attrs.name or "«name-missing»"}"
                 ];
               }

          b) For `nix-env`, `nix-build`, `nix-shell` or any other Nix command you can add
          ‘${attrs.name or "«name-missing»"}’ to `permittedInsecurePackages` in
          ~/.config/nixpkgs/config.nix, like so:

               {
                 permittedInsecurePackages = [
                   "${attrs.name or "«name-missing»"}"
                 ];
               }

        '';


      throwEvalHelp = { reason , errormsg ? "" }:
        throw (''
          Package ‘${attrs.name or "«name-missing»"}’ in ${pos_str} ${errormsg}, refusing to evaluate.

          '' + ((builtins.getAttr reason remediation) attrs));

      metaTypes = with lib.types; rec {
        # These keys are documented
        description = str;
        longDescription = str;
        branch = str;
        homepage = str;
        downloadPage = str;
        license = either (listOf lib.types.attrs) (either lib.types.attrs str);
        maintainers = listOf str;
        priority = int;
        platforms = listOf str;
        hydraPlatforms = listOf str;
        broken = bool;

        # Weirder stuff that doesn't appear in the documentation?
        version = str;
        tag = str;
        updateWalker = bool;
        executables = listOf str;
        outputsToInstall = listOf str;
        position = str;
        repositories = attrsOf str;
        isBuildPythonPackage = platforms;
        schedulingPriority = str;
        downloadURLRegexp = str;
        isFcitxEngine = bool;
        isIbusEngine = bool;
      };

      checkMetaAttr = k: v:
        if metaTypes?${k} then
          if metaTypes.${k}.check v then null else "key '${k}' has a value ${v} of an invalid type ${builtins.typeOf v}; expected ${metaTypes.${k}.description}"
        else "key '${k}' is unrecognized; expected one of: \n\t      [${lib.concatMapStringsSep ", " (x: "'${x}'") (lib.attrNames metaTypes)}]";
      checkMeta = meta: if shouldCheckMeta then lib.remove null (lib.mapAttrsToList checkMetaAttr meta) else [];

      # Check if a derivation is valid, that is whether it passes checks for
      # e.g brokenness or license.
      #
      # Return { valid: Bool } and additionally
      # { reason: String; errormsg: String } if it is not valid, where
      # reason is one of "unfree", "blacklisted" or "broken".
      checkValidity = attrs:
        if hasDeniedUnfreeLicense attrs && !(hasWhitelistedLicense attrs) then
          { valid = false; reason = "unfree"; errormsg = "has an unfree license (‘${showLicense attrs.meta.license}’)"; }
        else if hasBlacklistedLicense attrs then
          { valid = false; reason = "blacklisted"; errormsg = "has a blacklisted license (‘${showLicense attrs.meta.license}’)"; }
        else if !allowBroken && attrs.meta.broken or false then
          { valid = false; reason = "broken"; errormsg = "is marked as broken"; }
        else if !allowBroken && attrs.meta.platforms or null != null && !lib.lists.elem result.system attrs.meta.platforms then
          { valid = false; reason = "broken"; errormsg = "is not supported on ‘${result.system}’"; }
        else if !(hasAllowedInsecure attrs) then
          { valid = false; reason = "insecure"; errormsg = "is marked as insecure"; }
        else let res = checkMeta (attrs.meta or {}); in if res != [] then
          { valid = false; reason = "unknown-meta"; errormsg = "has an invalid meta attrset:${lib.concatMapStrings (x: "\n\t - " + x) res}"; }
        else { valid = true; };

      outputs' =
        outputs ++
        (if separateDebugInfo then assert targetPlatform.isLinux; [ "debug" ] else []);

      dependencies' = let
          justMap = map lib.chooseDevOutputs dependencies;
          nativeBuildInputs = lib.elemAt justMap 0
            ++ lib.optional targetPlatform.isWindows ../../build-support/setup-hooks/win-dll-link.sh;
          buildInputs = lib.elemAt justMap 1
               # TODO(@Ericson2314): Should instead also be appended to `nativeBuildInputs`.
            ++ lib.optional separateDebugInfo ../../build-support/setup-hooks/separate-debug-info.sh;
        in [ nativeBuildInputs buildInputs ];

      propagatedDependencies' = map lib.chooseDevOutputs propagatedDependencies;

      # Throw an error if trying to evaluate an non-valid derivation
      validityCondition =
             let v = checkValidity attrs;
             in if !v.valid
               then throwEvalHelp (removeAttrs v ["valid"])
               else true;

      derivationArg =
        (removeAttrs attrs
          ["meta" "passthru" "crossAttrs" "pos"
           "__impureHostDeps" "__propagatedImpureHostDeps"
           "sandboxProfile" "propagatedSandboxProfile"])
        // (let
          # TODO(@Ericson2314): Reversing of dep lists is just temporary to avoid Darwin mass rebuild.
          computedSandboxProfile =
            lib.concatMap (input: input.__propagatedSandboxProfile or []) (extraBuildInputs ++ lib.concatLists (lib.reverseList dependencies'));
          computedPropagatedSandboxProfile =
            lib.concatMap (input: input.__propagatedSandboxProfile or []) (lib.concatLists (lib.reverseList propagatedDependencies'));
          computedImpureHostDeps =
            lib.unique (lib.concatMap (input: input.__propagatedImpureHostDeps or []) (extraBuildInputs ++ lib.concatLists (lib.reverseList dependencies')));
          computedPropagatedImpureHostDeps =
            lib.unique (lib.concatMap (input: input.__propagatedImpureHostDeps or []) (lib.concatLists (lib.reverseList propagatedDependencies')));
        in
        {
          builder = attrs.realBuilder or shell;
          args = attrs.args or ["-e" (attrs.builder or ./default-builder.sh)];
          stdenv = result;
          system = result.system;
          userHook = config.stdenv.userHook or null;
          __ignoreNulls = true;

          nativeBuildInputs = lib.elemAt dependencies' 0;
          buildInputs = lib.elemAt dependencies' 1;

          propagatedNativeBuildInputs = lib.elemAt propagatedDependencies' 0;
          propagatedBuildInputs = lib.elemAt propagatedDependencies' 1;
        } // ifDarwin {
          # TODO: remove lib.unique once nix has a list canonicalization primitive
          __sandboxProfile =
          let profiles = [ extraSandboxProfile ] ++ computedSandboxProfile ++ computedPropagatedSandboxProfile ++ [ propagatedSandboxProfile sandboxProfile ];
              final = lib.concatStringsSep "\n" (lib.filter (x: x != "") (lib.unique profiles));
          in final;
          __propagatedSandboxProfile = lib.unique (computedPropagatedSandboxProfile ++ [ propagatedSandboxProfile ]);
          __impureHostDeps = computedImpureHostDeps ++ computedPropagatedImpureHostDeps ++ __propagatedImpureHostDeps ++ __impureHostDeps ++ __extraImpureHostDeps ++ [
            "/dev/zero"
            "/dev/random"
            "/dev/urandom"
            "/bin/sh"
          ];
          __propagatedImpureHostDeps = computedPropagatedImpureHostDeps ++ __propagatedImpureHostDeps;
        } // (if outputs' != [ "out" ] then {
          outputs = outputs';
        } else { }));

      # The meta attribute is passed in the resulting attribute set,
      # but it's not part of the actual derivation, i.e., it's not
      # passed to the builder and is not a dependency.  But since we
      # include it in the result, it *is* available to nix-env for queries.
      meta = { }
          # If the packager hasn't specified `outputsToInstall`, choose a default,
          # which is the name of `p.bin or p.out or p`;
          # if he has specified it, it will be overridden below in `// meta`.
          #   Note: This default probably shouldn't be globally configurable.
          #   Services and users should specify outputs explicitly,
          #   unless they are comfortable with this default.
        // { outputsToInstall =
          let
            outs = outputs'; # the value passed to derivation primitive
            hasOutput = out: builtins.elem out outs;
          in [( lib.findFirst hasOutput null (["bin" "out"] ++ outs) )];
        }
        // attrs.meta or {}
          # Fill `meta.position` to identify the source location of the package.
        // lib.optionalAttrs (pos != null)
          { position = pos.file + ":" + toString pos.line; }
        ;

    in

      assert validityCondition;

      lib.addPassthru (derivation derivationArg) (
        {
          overrideAttrs = f: mkDerivation (attrs // (f attrs));
          inherit meta passthru;
        } //
        # Pass through extra attributes that are not inputs, but
        # should be made available to Nix expressions using the
        # derivation (e.g., in assertions).
        passthru);

  # The stdenv that we are producing.
  result =
    derivation (
    (if isNull allowedRequisites then {} else { allowedRequisites = allowedRequisites ++ defaultNativeBuildInputs; }) //
    {
      inherit system name;

      builder = shell;

      args = ["-e" ./builder.sh];

      setup = setupScript;

      inherit preHook initialPath shell defaultNativeBuildInputs;
    }
    // ifDarwin {
      __sandboxProfile = stdenvSandboxProfile;
      __impureHostDeps = __stdenvImpureHostDeps;
    })

    // rec {

      meta = {
        description = "The default build environment for Unix packages in Nixpkgs";
        platforms = lib.platforms.all;
      };

      # Utility flags to test the type of platform.
      inherit (hostPlatform)
        isDarwin isLinux isSunOS isHurd isCygwin isFreeBSD isOpenBSD
        isi686 isx86_64 is64bit isMips isBigEndian;
      isArm = hostPlatform.isArm32;
      isAarch64 = hostPlatform.isArm64;

      # Whether we should run paxctl to pax-mark binaries.
      needsPax = isLinux;

      inherit mkDerivation;

      # For convenience, bring in the library functions in lib/ so
      # packages don't have to do that themselves.
      inherit lib;

      inherit fetchurlBoot;

      inherit overrides;

      inherit cc;
    }

    # Propagate any extra attributes.  For instance, we use this to
    # "lift" packages like curl from the final stdenv for Linux to
    # all-packages.nix for that platform (meaning that it has a line
    # like curl = if stdenv ? curl then stdenv.curl else ...).
    // extraAttrs;

in result)
