{
  mkDerivation,
  extra-cmake-modules, kdoctools,
  kcmutils, kcrash, kdeclarative, kdelibs4support, kglobalaccel, kidletime,
  kwayland, libXcursor, pam, plasma-framework, qtdeclarative, wayland
}:

mkDerivation {
  name = "kscreenlocker";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kcmutils kcrash kdeclarative kdelibs4support kglobalaccel kidletime kwayland
    libXcursor pam plasma-framework qtdeclarative wayland
  ];
}
