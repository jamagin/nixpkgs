{ supportedSystems, packageSet ? (import ./all-packages.nix) }:

with import ../../lib;

rec {

  # Ensure that we don't build packages marked as unfree.
  allPackages = args: packageSet (args // {
    config.allowUnfree = false;
  });

  pkgs = pkgsFor "x86_64-linux";


  /* !!! Hack: poor man's memoisation function.  Necessary to prevent
     Nixpkgs from being evaluated again and again for every
     job/platform pair. */
  pkgsFor = system:
    if system == "x86_64-linux" then pkgs_x86_64_linux
    else if system == "i686-linux" then pkgs_i686_linux
    else if system == "x86_64-darwin" then pkgs_x86_64_darwin
    else if system == "x86_64-freebsd" then pkgs_x86_64_freebsd
    else if system == "i686-freebsd" then pkgs_i686_freebsd
    else if system == "i686-cygwin" then pkgs_i686_cygwin
    else abort "unsupported system type: ${system}";

  pkgs_x86_64_linux = allPackages { system = "x86_64-linux"; };
  pkgs_i686_linux = allPackages { system = "i686-linux"; };
  pkgs_x86_64_darwin = allPackages { system = "x86_64-darwin"; };
  pkgs_x86_64_freebsd = allPackages { system = "x86_64-freebsd"; };
  pkgs_i686_freebsd = allPackages { system = "i686-freebsd"; };
  pkgs_i686_cygwin = allPackages { system = "i686-cygwin"; };


  /* The working or failing mails for cross builds will be sent only to
     the following maintainers, as most package maintainers will not be
     interested in the result of cross building a package. */
  crossMaintainers = [ maintainers.viric ];


  toJob = x: if isAttrs x then x else
    { type = "job"; systems = x; };


  /* Build a package on the given set of platforms.  The function `f'
     is called for each supported platform with Nixpkgs for that
     platform as an argument .  We return an attribute set containing
     a derivation for each supported platform, i.e. ‘{ x86_64-linux =
     f pkgs_x86_64_linux; i686-linux = f pkgs_i686_linux; ... }’. */
  testOn = systems: f: genAttrs
    (filter (x: elem x supportedSystems) systems)
    (system: f (pkgsFor system));


  /* Similar to the testOn function, but with an additional
     'crossSystem' parameter for allPackages, defining the target
     platform for cross builds. */
  testOnCross = crossSystem: systems: f: {system ? builtins.currentSystem}:
    if elem system systems
    then f (allPackages { inherit system crossSystem; })
    else {};


  /* Map an attribute of the form `foo = [platforms...]'  to `testOn
     [platforms...] (pkgs: pkgs.foo)'. */
  mapTestOn = mapAttrsRecursiveCond
    (as: as.type or "" != "job")
    (path: value:
      let
        job = toJob value;
        getPkg = pkgs: getAttrFromPath path pkgs;
      in testOn job.systems getPkg);


  /* Similar to the testOn function, but with an additional 'crossSystem'
   * parameter for allPackages, defining the target platform for cross builds,
   * and triggering the build of the host derivation (cross built - crossDrv). */
  mapTestOnCross = crossSystem: mapAttrsRecursiveCond
    (as: as.type or "" != "job")
    (path: value:
      let
        job = toJob value;
        getPkg = pkgs: addMetaAttrs { maintainers = crossMaintainers; }
          (getAttrFromPath path pkgs);
      in testOnCross crossSystem job.systems getPkg);


  /* Find all packages that have a meta.platforms field listing the
     supported platforms. */
  packagesWithMetaPlatform = attrSet:
    let pairs = concatMap
      (x:
        let pair = builtins.tryEval
              (let
                 attrVal = attrSet.${x};
               in
                 { val = processPackage attrVal;
                   attrVal = attrVal;
                   attrValIsAttrs = isAttrs attrVal;
                 });
            success = (builtins.tryEval pair.value.attrVal).success;
        in
        optional (success && pair.value.attrValIsAttrs && pair.value.val != [])
          { name = x; value = pair.value.val; })
      (attrNames attrSet);
    in
      listToAttrs pairs;


  # May fail as much as it wishes, we will catch the error.
  processPackage = attrSet:
    if attrSet.recurseForDerivations or false || attrSet.recurseForRelease or false then
      packagesWithMetaPlatform attrSet
    else if attrSet.meta.broken or false then
      []
    else
      attrSet.meta.hydraPlatforms or (attrSet.meta.platforms or []);


  /* Common platform groups on which to test packages. */
  inherit (platforms) unix linux darwin cygwin allBut all mesaPlatforms;

  /* Platform groups for specific kinds of applications. */
  x11Supported = linux;
  gtkSupported = linux;
  ghcSupported = linux;

}
