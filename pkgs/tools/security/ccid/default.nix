{ stdenv, fetchurl, pcsclite, pkgconfig, libusb1, perl }:

stdenv.mkDerivation rec {
  version = "1.4.26";
  name = "ccid-${version}";

  src = fetchurl {
    url = "https://alioth.debian.org/frs/download.php/file/4205/ccid-1.4.26.tar.bz2";
    sha256 = "0bxy835c133ajalpj4gx60nqkjvpf9y1n97n04pw105pi9qbyrrj";
  };

  patchPhase = ''
    patchShebangs .
    substituteInPlace src/Makefile.in --replace /bin/echo echo
  '';

  preConfigure = ''
    configureFlagsArray+=("--enable-usbdropdir=$out/pcsc/drivers")
  '';

  nativeBuildInputs = [ pkgconfig perl ];
  buildInputs = [ pcsclite libusb1 ];

  meta = with stdenv.lib; {
    description = "ccid drivers for pcsclite";
    homepage = http://pcsclite.alioth.debian.org/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ viric wkennington ];
    platforms = platforms.linux;
  };
}
