{
  mkDerivation,
  extra-cmake-modules,
  gconf, glib, kdoctools, kconfigwidgets, kcoreaddons, kdeclarative, kglobalaccel,
  ki18n, libcanberra_gtk3, libpulseaudio, plasma-framework
}:

mkDerivation {
  name = "plasma-pa";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    gconf glib kconfigwidgets kcoreaddons kdeclarative
    kglobalaccel ki18n libcanberra_gtk3 libpulseaudio plasma-framework
  ];
}
