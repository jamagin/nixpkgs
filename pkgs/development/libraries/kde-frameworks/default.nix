/*

# New packages

READ THIS FIRST

This module is for official packages in KDE Frameworks 5. All available packages
are listed in `./srcs.nix`, although a few are not yet packaged in Nixpkgs (see
below).

IF YOUR PACKAGE IS NOT LISTED IN `./srcs.nix`, IT DOES NOT GO HERE.

Many of the packages released upstream are not yet built in Nixpkgs due to lack
of demand. To add a Nixpkgs build for an upstream package, copy one of the
existing packages here and modify it as necessary.

# Updates

1. Update the URL in `./fetch.sh`.
2. Run `./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/kde-frameworks`
   from the top of the Nixpkgs tree.
3. Use `nox-review wip` to check that everything builds.
4. Commit the changes and open a pull request.

*/

{ libsForQt5, lib, fetchurl }:

let

  srcs = import ./srcs.nix {
    inherit fetchurl;
    mirror = "mirror://kde";
  };

  mkDerivation = libsForQt5.callPackage ({ mkDerivation }: mkDerivation) {};

  packages = self: with self;
    let

      propagateBin =
        let setupHook = { writeScript }:
              writeScript "setup-hook.sh" ''
                # Propagate $bin output
                propagatedUserEnvPkgs+=" @bin@"

                # Propagate $dev so that this setup hook is propagated
                # But only if there is a separate $dev output
                if [ "$outputDev" != out ]; then
                    if [ -n "$crossConfig" ]; then
                      propagatedBuildInputs+=" @dev@"
                    else
                      propagatedNativeBuildInputs+=" @dev@"
                    fi
                fi
              '';
        in callPackage setupHook {};

      callPackage = self.newScope {

        inherit propagateBin;

        mkDerivation = args:
          let

            inherit (args) name;
            inherit (srcs."${name}") src version;

            outputs = args.outputs or [ "out" "dev" "bin" ];
            hasBin = lib.elem "bin" outputs;
            hasDev = lib.elem "dev" outputs;

            defaultSetupHook = if hasBin && hasDev then propagateBin else null;
            setupHook = args.setupHook or defaultSetupHook;

            meta = {
              homepage = "http://www.kde.org";
              license = with lib.licenses; [
                lgpl21Plus lgpl3Plus bsd2 mit gpl2Plus gpl3Plus fdl12
              ];
              maintainers = [ lib.maintainers.ttuegel ];
              platforms = lib.platforms.linux;
            } // (args.meta or {});

          in mkDerivation (args // {
            name = "${name}-${version}";
            inherit meta outputs setupHook src;
          });

      };

    in {
      attica = callPackage ./attica.nix {};
      baloo = callPackage ./baloo.nix {};
      bluez-qt = callPackage ./bluez-qt.nix {};
      breeze-icons = callPackage ./breeze-icons.nix {};
      extra-cmake-modules = callPackage ./extra-cmake-modules {};
      frameworkintegration = callPackage ./frameworkintegration.nix {};
      kactivities = callPackage ./kactivities.nix {};
      kactivities-stats = callPackage ./kactivities-stats.nix {};
      kapidox = callPackage ./kapidox.nix {};
      karchive = callPackage ./karchive.nix {};
      kauth = callPackage ./kauth {};
      kbookmarks = callPackage ./kbookmarks.nix {};
      kcmutils = callPackage ./kcmutils {};
      kcodecs = callPackage ./kcodecs.nix {};
      kcompletion = callPackage ./kcompletion.nix {};
      kconfig = callPackage ./kconfig.nix {};
      kconfigwidgets = callPackage ./kconfigwidgets {};
      kcoreaddons = callPackage ./kcoreaddons.nix {};
      kcrash = callPackage ./kcrash.nix {};
      kdbusaddons = callPackage ./kdbusaddons.nix {};
      kdeclarative = callPackage ./kdeclarative.nix {};
      kded = callPackage ./kded.nix {};
      kdelibs4support = callPackage ./kdelibs4support {};
      kdesignerplugin = callPackage ./kdesignerplugin.nix {};
      kdesu = callPackage ./kdesu.nix {};
      kdnssd = callPackage ./kdnssd.nix {};
      kdoctools = callPackage ./kdoctools {};
      kemoticons = callPackage ./kemoticons.nix {};
      kfilemetadata = callPackage ./kfilemetadata {};
      kglobalaccel = callPackage ./kglobalaccel.nix {};
      kguiaddons = callPackage ./kguiaddons.nix {};
      khtml = callPackage ./khtml.nix {};
      ki18n = callPackage ./ki18n.nix {};
      kiconthemes = callPackage ./kiconthemes {};
      kidletime = callPackage ./kidletime.nix {};
      kimageformats = callPackage ./kimageformats.nix {};
      kinit = callPackage ./kinit {};
      kio = callPackage ./kio {};
      kitemmodels = callPackage ./kitemmodels.nix {};
      kitemviews = callPackage ./kitemviews.nix {};
      kjobwidgets = callPackage ./kjobwidgets.nix {};
      kjs = callPackage ./kjs.nix {};
      kjsembed = callPackage ./kjsembed.nix {};
      kmediaplayer = callPackage ./kmediaplayer.nix {};
      knewstuff = callPackage ./knewstuff.nix {};
      knotifications = callPackage ./knotifications.nix {};
      knotifyconfig = callPackage ./knotifyconfig.nix {};
      kpackage = callPackage ./kpackage {};
      kparts = callPackage ./kparts.nix {};
      kpeople = callPackage ./kpeople.nix {};
      kplotting = callPackage ./kplotting.nix {};
      kpty = callPackage ./kpty.nix {};
      kross = callPackage ./kross.nix {};
      krunner = callPackage ./krunner.nix {};
      kservice = callPackage ./kservice {};
      ktexteditor = callPackage ./ktexteditor.nix {};
      ktextwidgets = callPackage ./ktextwidgets.nix {};
      kunitconversion = callPackage ./kunitconversion.nix {};
      kwallet = callPackage ./kwallet.nix {};
      kwayland = callPackage ./kwayland.nix {};
      kwidgetsaddons = callPackage ./kwidgetsaddons.nix {};
      kwindowsystem = callPackage ./kwindowsystem {};
      kxmlgui = callPackage ./kxmlgui.nix {};
      kxmlrpcclient = callPackage ./kxmlrpcclient.nix {};
      modemmanager-qt = callPackage ./modemmanager-qt.nix {};
      networkmanager-qt = callPackage ./networkmanager-qt.nix {};
      oxygen-icons5 = callPackage ./oxygen-icons5.nix {};
      plasma-framework = callPackage ./plasma-framework.nix {};
      solid = callPackage ./solid.nix {};
      sonnet = callPackage ./sonnet.nix {};
      syntax-highlighting = callPackage ./syntax-highlighting.nix {};
      threadweaver = callPackage ./threadweaver.nix {};
    };

in lib.makeScope libsForQt5.newScope packages
