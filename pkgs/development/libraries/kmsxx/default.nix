{ stdenv, fetchgit, cmake, pkgconfig, libdrm, python }:

stdenv.mkDerivation rec {
  name = "kmsxx-2017-10-03";

  src = fetchgit {
    url = "https://github.com/tomba/kmsxx";
    fetchSubmodules = true;
    rev = "35d54fdddd6d7add49efbb0d9dec30816de96c90";
    sha256 = "144gjqz6bxsn4j7k8q8309ph9czmr8rd4vzwfayw3airplnz5zka";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libdrm python ];

  pythonPath = [ ];
  passthru.python = python;

  meta = with stdenv.lib; {
    description = "C++11 library, utilities and python bindings for Linux kernel mode setting";
    homepage = https://github.com/tomba/kmsxx;
    license = licenses.mpl20;
    maintainers = [ maintainers.gnidorah ];
    platforms = platforms.linux;
  };
}
