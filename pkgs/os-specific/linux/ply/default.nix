{ stdenv, kernel, fetchFromGitHub, autoreconfHook, yacc, flex, bison }:
let
  version = "1.0.beta1-9e810b1";
in stdenv.mkDerivation {
  name = "ply-${version}";
  nativeBuildInputs = [ autoreconfHook flex yacc ];

  src = fetchFromGitHub {
    owner = "iovisor";
    repo = "ply";
    rev = "9e810b157ba079c32c430a7d4c6034826982056e";
    sha256 = "15cp6iczawaqlhsa0af6i37zn5iq53kh6ya8s2hzd018yd7mhg50";
  };

  preAutoreconf = ''
    # ply wants to install header fails to its build directory
    xz -d < ${kernel.src} | tar -xf -
    configureFlagsArray+=(--with-kerneldir=$(echo $(pwd)/linux-*))
    ./autogen.sh --prefix=$out
  '';

  meta = with stdenv.lib; {
    description = "dynamic Tracing in Linux";
    homepage = https://wkz.github.io/ply/;
    license = [ licenses.gpl2 ];
    maintainers = with maintainers; [ mic92 mbbx6spp ];
  };
}
