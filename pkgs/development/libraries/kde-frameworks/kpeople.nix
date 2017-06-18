{
  mkDerivation, lib,
  extra-cmake-modules,
  kcoreaddons, ki18n, kitemviews, kservice, kwidgetsaddons, qtbase,
  qtdeclarative,
}:

mkDerivation {
  name = "kpeople";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kcoreaddons ki18n kitemviews kservice kwidgetsaddons qtdeclarative
  ];
  propagatedBuildInputs = [ qtbase ];
}
