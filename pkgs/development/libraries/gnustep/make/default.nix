{ stdenv, fetchurl, clang, which, libobjc2 }:
let
  version = "2.6.8";
in
stdenv.mkDerivation rec {
  name = "gnustep-make-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-make-${version}.tar.gz";
    sha256 = "0r00439f7vrggdwv60n8p626gnyymhq968i5x9ad2i4v6g8x4gk0";
  };
  configureFlags = "--with-installation-domain=SYSTEM";
  buildInputs = [ clang which libobjc2 ];
  patches = [ ./fixup-paths.patch ];
  setupHook = ./setup-hook.sh;
  meta = {
    description = "GNUstep-make is a build manager for GNUstep.";

    homepage = http://gnustep.org/;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = with stdenv.lib.maintainers; [ ashalkhakov matthewbauer ];
    platforms = stdenv.lib.platforms.linux;
  };
}
