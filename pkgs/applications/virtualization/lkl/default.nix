{ stdenv, fetchFromGitHub, bc, python, fuse, libarchive }:

stdenv.mkDerivation rec {
  name = "lkl-2017-03-24";
  rev  = "a063e1631db5e2b9b04f184c5e6d185c1cd645cb";

  nativeBuildInputs = [ bc python ];

  buildInputs = [ fuse libarchive ];

  src = fetchFromGitHub {
    inherit rev;
    owner  = "lkl";
    repo   = "linux";
    sha256 = "07dmira76i0ki577sra4fdl1wvzfzxzd75252lza0sc6jdzrrwvj";
  };

  # Fix a /usr/bin/env reference in here that breaks sandboxed builds
  prePatch = "patchShebangs arch/lkl/scripts";

  installPhase = ''
    mkdir -p $out/{bin,lib}

    # This tool assumes a different directory structure so let's point it at the right location
    cp tools/lkl/bin/lkl-hijack.sh $out/bin
    substituteInPlace $out/bin/lkl-hijack.sh --replace '/../' '/../lib'

    cp tools/lkl/{cptofs,cpfromfs,fs2tar,lklfuse} $out/bin
    cp -r tools/lkl/include $out
    cp tools/lkl/liblkl*.{a,so} $out/lib
  '';

  # We turn off format and fortify because of these errors (fortify implies -O2, which breaks the jitter entropy code):
  #   fs/xfs/xfs_log_recover.c:2575:3: error: format not a string literal and no format arguments [-Werror=format-security]
  #   crypto/jitterentropy.c:54:3: error: #error "The CPU Jitter random number generator must not be compiled with optimizations. See documentation. Use the compiler switch -O0 for compiling jitterentropy.c."
  hardeningDisable = [ "format" "fortify" ];

  makeFlags = "-C tools/lkl";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "LKL (Linux Kernel Library) aims to allow reusing the Linux kernel code as extensively as possible with minimal effort and reduced maintenance overhead";
    homepage    = https://github.com/lkl/linux/;
    platforms   = [ "x86_64-linux" ]; # Darwin probably works too but I haven't tested it
    license     = licenses.gpl2;
    maintainers = with maintainers; [ copumpkin ];
  };
}
