{ stdenv, fetchFromGitHub, cmake, libpfm, zlib, pkgconfig, python2Packages, which, procps, gdb }:

stdenv.mkDerivation rec {
  version = "4.4.0";
  name = "rr-${version}";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "rr";
    rev = version;
    sha256 = "1ijzs5lwscg0k5ch1bljiqqh35rzai75xcgghgkjbz86ynmf62rd";
  };

  postPatch = ''
    substituteInPlace src/Command.cc --replace '_BSD_SOURCE' '_DEFAULT_SOURCE'
    sed '7i#include <math.h>' -i src/Scheduler.cc
    patchShebangs .
  '';

  buildInputs = [
    cmake libpfm zlib python2Packages.python pkgconfig python2Packages.pexpect which procps gdb
  ];
  cmakeFlags = [
    "-DCMAKE_C_FLAGS_RELEASE:STRING="
    "-DCMAKE_CXX_FLAGS_RELEASE:STRING="
    "-Ddisable32bit=ON"
  ];

  # we turn on additional warnings due to hardening
  NIX_CFLAGS_COMPILE = "-Wno-error";

  hardeningDisable = [ "fortify" ];

  enableParallelBuilding = true;

  # FIXME
  #doCheck = true;

  preCheck = "export HOME=$TMPDIR";

  meta = {
    homepage = http://rr-project.org/;
    description = "Records nondeterministic executions and debugs them deterministically";
    longDescription = ''
      rr aspires to be your primary debugging tool, replacing -- well,
      enhancing -- gdb. You record a failure once, then debug the
      recording, deterministically, as many times as you want. Every
      time the same execution is replayed.
    '';

    license = "custom";
    maintainers = with stdenv.lib.maintainers; [ pierron thoughtpolice ];
    platforms = stdenv.lib.platforms.linux;
  };
}
