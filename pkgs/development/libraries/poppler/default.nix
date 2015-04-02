{ stdenv, fetchurl, fetchpatch, pkgconfig, libiconv, libintlOrEmpty
, zlib, curl, cairo, freetype, fontconfig, lcms, libjpeg, openjpeg
, qt4Support ? false, qt4 ? null, qt5
}:

let
  version = "0.32.0"; # even major numbers are stable
  sha256 = "162vfbvbz0frvqyk00ldsbl49h4bj8i8wn0ngfl30xg1lldy6qs9";

  poppler_drv = nameSuff: merge: stdenv.mkDerivation (stdenv.lib.mergeAttrsByFuncDefaultsClean [
  rec {
    name = "poppler-${nameSuff}-${version}";

    src = fetchurl {
      url = "${meta.homepage}/poppler-${version}.tar.xz";
      inherit sha256;
    };

    propagatedBuildInputs = [ zlib cairo freetype fontconfig libjpeg lcms curl openjpeg ];

    nativeBuildInputs = [ pkgconfig libiconv ] ++ libintlOrEmpty;

    configureFlags = [
      "--enable-xpdf-headers"
      "--enable-libcurl"
      "--enable-zlib"
    ];

    patches = [ ./datadir_env.patch ./poppler-glib.patch ];

    # XXX: The Poppler/Qt4 test suite refers to non-existent PDF files
    # such as `../../../test/unittestcases/UseNone.pdf'.
    #doCheck = !qt4Support;
    checkTarget = "test";

    enableParallelBuilding = true;

    meta = {
      homepage = http://poppler.freedesktop.org/;
      description = "A PDF rendering library";

      longDescription = ''
        Poppler is a PDF rendering library based on the xpdf-3.0 code base.
      '';

      license = stdenv.lib.licenses.gpl2;
      platforms = stdenv.lib.platforms.all;
    };
  } merge ]); # poppler_drv

  /* We always use cairo in poppler, so we always depend on glib,
     so we always build the glib wrapper (~350kB).
     We also always build the cpp wrapper (<100kB).
     ToDo: around half the size could be saved by splitting out headers and tools (1.5 + 0.5 MB).
  */

  poppler_glib = poppler_drv "glib" { };

  poppler_qt4 = poppler_drv "qt4" {
    #patches = [ qtcairo_patch ]; # text rendering artifacts in recent versions
    propagatedBuildInputs = [ qt4 poppler_glib ];
    NIX_LDFLAGS = "-lpoppler";
    postConfigure = ''
      mkdir -p "$out/lib/pkgconfig"
      install -c -m 644 poppler-qt4.pc "$out/lib/pkgconfig"
      cd qt4
    '';
  };

  poppler_qt5 = poppler_drv "qt5" {
    propagatedBuildInputs = [ qt5.base poppler_glib ];
    postConfigure = ''
      mkdir -p "$out/lib/pkgconfig"
      install -c -m 644 poppler-qt5.pc "$out/lib/pkgconfig"
      cd qt5
    '';
  };

in { inherit poppler_glib poppler_qt4 poppler_qt5; } // poppler_glib
