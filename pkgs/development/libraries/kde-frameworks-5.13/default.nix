# Maintainer's Notes:
#
# How To Update
#  1. Edit the URL in ./manifest.sh
#  2. Run ./manifest.sh
#  3. Fix build errors.

{ pkgs, debug ? false }:

let

  inherit (pkgs) lib;

  mirror = "mirror://kde";
  srcs = import ./srcs.nix { inherit (pkgs) fetchurl; inherit mirror; };

  mkDerivation = args:
    let
      inherit (args) name;
      inherit (srcs."${name}") src version;
      inherit (pkgs.stdenv) mkDerivation;
    in mkDerivation (args // {
      name = "${name}-${version}";
      inherit src;

      cmakeFlags =
        (args.cmakeFlags or [])
        ++ [ "-DBUILD_TESTING=OFF" ]
        ++ lib.optional debug "-DCMAKE_BUILD_TYPE=Debug";

      meta = {
        license = with lib.licenses; [
          lgpl21Plus lgpl3Plus bsd2 mit gpl2Plus gpl3Plus fdl12
        ];
        platforms = lib.platforms.linux;
        homepage = "http://www.kde.org";
      } // (args.meta or {});
    });

  addPackages = self: with self; {
    attica = callPackage ./attica.nix {};
    baloo = callPackage ./baloo.nix {};
    bluez-qt = callPackage ./bluez-qt.nix {};
    extra-cmake-modules = callPackage ./extra-cmake-modules {};
    frameworkintegration = callPackage ./frameworkintegration.nix {};
    kactivities = callPackage ./kactivities.nix {};
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
    kdelibs4support = callPackage ./kdelibs4support.nix {};
    kdesignerplugin = callPackage ./kdesignerplugin.nix {};
    kdewebkit = callPackage ./kdewebkit.nix {};
    kdesu = callPackage ./kdesu.nix {};
    kdnssd = callPackage ./kdnssd.nix {};
    kdoctools = callPackage ./kdoctools {};
    kemoticons = callPackage ./kemoticons.nix {};
    kfilemetadata = callPackage ./kfilemetadata.nix {};
    kglobalaccel = callPackage ./kglobalaccel.nix {};
    kguiaddons = callPackage ./kguiaddons.nix {};
    khtml = callPackage ./khtml.nix {};
    ki18n = callPackage ./ki18n.nix {};
    kiconthemes = callPackage ./kiconthemes.nix {};
    kidletime = callPackage ./kidletime.nix {};
    kimageformats = callPackage ./kimageformats.nix {};
    kinit = callPackage ./kinit {};
    kio = callPackage ./kio.nix {};
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
    ktexteditor = callPackage ./ktexteditor {};
    ktextwidgets = callPackage ./ktextwidgets.nix {};
    kunitconversion = callPackage ./kunitconversion.nix {};
    kwallet = callPackage ./kwallet.nix {};
    kwidgetsaddons = callPackage ./kwidgetsaddons.nix {};
    kwindowsystem = callPackage ./kwindowsystem.nix {};
    kxmlgui = callPackage ./kxmlgui.nix {};
    kxmlrpcclient = callPackage ./kxmlrpcclient.nix {};
    modemmanager-qt = callPackage ./modemmanager-qt.nix {};
    networkmanager-qt = callPackage ./networkmanager-qt.nix {};
    plasma-framework = callPackage ./plasma-framework {};
    solid = callPackage ./solid.nix {};
    sonnet = callPackage ./sonnet.nix {};
    threadweaver = callPackage ./threadweaver.nix {};
  };

  newScope = scope: pkgs.qt55Libs.newScope ({ inherit mkDerivation; } // scope);

in lib.makeScope newScope addPackages
