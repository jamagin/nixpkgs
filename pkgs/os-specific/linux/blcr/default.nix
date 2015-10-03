{ stdenv, lib, fetchurl, kernel, perl, makeWrapper }:

# BLCR 0.8.5 should works for kernel version up to 3.7.1
# BLCR 0.8.6 should works for kernel version up to 3.17.x

assert stdenv.isLinux;
assert builtins.compareVersions "3.18" kernel.version == 1;

# it doesn't compile anymore on 3.12
assert lib.versionAtLeast kernel.version "3.14";

stdenv.mkDerivation {
  name = "blcr_${kernel.version}-0.8.6pre4";

  src = fetchurl {
    url = https://upc-bugs.lbl.gov/blcr-dist/blcr-0.8.6_b4.tar.gz;
    sha256 = "1a3gdhdnmk592jc652szxgfz8rjd8dax5jwxfsypiqx5lgkj3m21";
  };

  buildInputs = [ perl makeWrapper ];

  preConfigure = ''
    configureFlagsArray=(
      --with-linux=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build
      --with-kmod-dir=$out/lib/modules/${kernel.modDirVersion}
      --with-system-map=${kernel}/System.map
    )
  '';

  postInstall = ''
    for prog in "$out/bin/"*
    do
      wrapProgram "$prog" --prefix LD_LIBRARY_PATH ":" "$out/lib"
    done
  '';
      
  meta = {
    description = "Berkeley Lab Checkpoint/Restart for Linux (BLCR)";
    homepage = https://ftg.lbl.gov/projects/CheckpointRestart/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [
      z77z
    ];
  };
}
