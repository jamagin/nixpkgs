{ mkDerivation, lib, extra-cmake-modules, attica, kconfig
, kconfigwidgets, kglobalaccel, ki18n, kiconthemes, kitemviews
, ktextwidgets, kwindowsystem, sonnet
}:

mkDerivation {
  name = "kxmlgui";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    attica kconfig kconfigwidgets kglobalaccel ki18n kiconthemes kitemviews
    ktextwidgets kwindowsystem sonnet
  ];
}
