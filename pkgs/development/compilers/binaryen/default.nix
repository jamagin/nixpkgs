{ stdenv, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "32";
  rev = "version_${version}";
  name = "binaryen-${version}";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    sha256 = "0zclw6pa2pkzrnp8ib9qwbjvq38r2h5ynfg8fjl99b5lcyz5m590";
    inherit rev;
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = https://github.com/WebAssembly/binaryen;
    description = "Compiler infrastructure and toolchain library for WebAssembly, in C++";
    platforms = platforms.all;
    maintainers = with maintainers; [ asppsa ];
    license = licenses.asl20;
  };
}
