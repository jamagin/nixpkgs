{ stdenv, fetchurl, kernel ? null, xlibs, zlib, perl
, gtk, atk, pango, glib, gdk_pixbuf
, # Whether to build the libraries only (i.e. not the kernel module or
  # nvidia-settings).  Used to support 32-bit binaries on 64-bit
  # Linux.
  libsOnly ? false
}:

with stdenv.lib;

assert (!libsOnly) -> kernel != null;

let

  versionNumber = "343.36";
  /* This branch is needed for G8x, G9x, and GT2xx GPUs, and motherboard chipsets based on them.
    Ongoing support for new Linux kernels and X servers, as well as fixes for critical bugs,
    will be included in 340.* legacy releases through the end of 2019.
  */
  inherit (stdenv.lib) makeLibraryPath;
in

stdenv.mkDerivation {
  name = "nvidia-x11-${versionNumber}${optionalString (!libsOnly) "-${kernel.version}"}";

  builder = ./builder.sh;

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://us.download.nvidia.com/XFree86/Linux-x86/${versionNumber}/NVIDIA-Linux-x86-${versionNumber}.run";
        sha256 = "17l23dp725883xcyy1n178pcl6lj27psrgbxymc356x2pngwkhcc";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://us.download.nvidia.com/XFree86/Linux-x86_64/${versionNumber}/NVIDIA-Linux-x86_64-${versionNumber}-no-compat32.run";
        sha256 = "0djvh9wmazrfvpgyiqrz81kjk2war20xyjjr2kncxyplzk28mw97";
      }
    else throw "nvidia-x11 does not support platform ${stdenv.system}";

  inherit versionNumber libsOnly;

  kernel = if libsOnly then null else kernel.dev;

  dontStrip = true;

  glPath      = makeLibraryPath [xlibs.libXext xlibs.libX11 xlibs.libXrandr];
  cudaPath    = makeLibraryPath [zlib stdenv.gcc.gcc];
  openclPath  = makeLibraryPath [zlib];
  allLibPath  = makeLibraryPath [xlibs.libXext xlibs.libX11 xlibs.libXrandr zlib stdenv.gcc.gcc];

  programPath = optionalString (!libsOnly) (makeLibraryPath
    [ gtk atk pango glib gdk_pixbuf xlibs.libXv ] );

  buildInputs = [ perl ];

  meta = with stdenv.lib.meta; {
    homepage = http://www.nvidia.com/object/unix.html;
    description = "X.org driver and kernel module for NVIDIA graphics cards";
    license = licenses.unfreeRedistributable;
    platforms = platforms.linux;
    maintainers = [ maintainers.vcunat ];
  };
}
