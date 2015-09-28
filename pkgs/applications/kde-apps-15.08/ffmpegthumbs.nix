{ mkDerivation
, lib
, automoc4
, cmake
, perl
, pkgconfig
, kdelibs
, ffmpeg
}:

mkDerivation {
  name = "ffmpegthumbs";
  nativeBuildInputs = [
    automoc4
    cmake
    perl
    pkgconfig
  ];
  buildInputs = [
    kdelibs
    ffmpeg
  ];
  meta = {
    license = with lib.licenses; [ gpl2 bsd3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
