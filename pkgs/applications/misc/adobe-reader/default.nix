{ stdenv, fetchurl, libX11, cups, zlib, libxml2, pango, atk, gtk, glib
, gdk_pixbuf }:

assert stdenv.system == "i686-linux";

let version = "9.5.1"; in

stdenv.mkDerivation {
  name = "adobe-reader-${version}-1";

  builder = ./builder.sh;

  src = fetchurl {
    url = "http://ardownload.adobe.com/pub/adobe/reader/unix/9.x/${version}/enu/AdbeRdr${version}-1_i486linux_enu.tar.bz2";
    sha256 = "19mwhbfsivb21zmrz2hllf0kh4i225ac697y026bakyysn0vig56";
  };

  # !!! Adobe Reader contains copies of OpenSSL, libcurl, and libicu.
  # We should probably remove those and use the regular Nixpkgs
  # versions.

  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.gcc.gcc libX11 zlib libxml2 cups pango atk gtk glib gdk_pixbuf ];

  meta = {
    description = "Adobe Reader, a viewer for PDF documents";
    homepage = http://www.adobe.com/products/reader;
    license = "unfree";
  };
}
