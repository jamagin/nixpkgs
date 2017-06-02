{
  mkDerivation, lib, kdeWrapper,
  extra-cmake-modules, kdoctools, makeQtWrapper,
  baloo, baloo-widgets, dolphin-plugins, kactivities, kbookmarks, kcmutils,
  kcompletion, kconfig, kcoreaddons, kdelibs4support, kdbusaddons,
  kfilemetadata, ki18n, kiconthemes, kinit, kio, knewstuff, knotifications,
  konsole, kparts, ktexteditor, kwindowsystem, phonon, solid
}:

let
  unwrapped =
    mkDerivation {
      name = "dolphin";
      meta = {
        license = with lib.licenses; [ gpl2 fdl12 ];
        maintainers = [ lib.maintainers.ttuegel ];
      };
      nativeBuildInputs = [ extra-cmake-modules kdoctools makeQtWrapper ];
      propagatedBuildInputs = [
        baloo baloo-widgets kactivities kbookmarks kcmutils kcompletion kconfig
        kcoreaddons kdelibs4support kdbusaddons kfilemetadata ki18n kiconthemes
        kinit kio knewstuff knotifications kparts ktexteditor kwindowsystem
        phonon solid
      ];
    };
in
kdeWrapper
{
  inherit unwrapped;
  targets = [ "bin/dolphin" ];
  paths = [ dolphin-plugins konsole.unwrapped ];
}
