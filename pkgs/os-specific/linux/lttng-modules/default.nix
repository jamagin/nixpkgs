{ stdenv, fetchgit, kernel }:

assert stdenv.lib.versionAtLeast kernel.version "3.4";  # fails on 3.2

stdenv.mkDerivation rec {
  pname = "lttng-modules-${rev}";
  name = "${pname}-${kernel.version}";
  rev = "bf2ba318fff";

  src = fetchgit {
    url = "https://github.com/lttng/lttng-modules.git";
    sha256 = "0x70xp463g208rdz5b9b0wdwr2v8px1bwa589knvp4j7zi8d2gj9";
    inherit rev;
  };

  preConfigure = ''
    export KERNELDIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    export INSTALL_MOD_PATH="$out"
  '';

  installPhase = ''
    make modules_install
  '';

  meta = with stdenv.lib; {
    description = "Linux kernel modules for LTTng tracing";
    homepage = http://lttng.org/;
    # TODO license = with licenses; [ lgpl21 gpl2 mit ];
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
