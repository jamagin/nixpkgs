{ fetchurl, stdenv, libuuid, popt, icu, ncurses }:

let version = "1.0.1"; in
stdenv.mkDerivation rec {
  name = "gptfdisk-${version}";

  src = fetchurl {
    # http://www.rodsbooks.com/gdisk/${name}.tar.gz also works, but the home
    # page clearly implies a preference for using SourceForge's bandwidth:
    url = "mirror://sourceforge/gptfdisk/${name}.tar.gz";
    sha256 = "1izazbyv5n2d81qdym77i8mg9m870hiydmq4d0s51npx5vp8lk46";
  };

  patchPhase = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile.mac --replace \
      "-mmacosx-version-min=10.4" "-mmacosx-version-min=10.6"
    substituteInPlace Makefile.mac --replace \
      " -arch i386" ""
    substituteInPlace Makefile.mac --replace \
      " -I/opt/local/include -I /usr/local/include -I/opt/local/include" ""
    substituteInPlace Makefile.mac --replace \
      "/opt/local/lib/libncurses.a" "${ncurses.lib}/lib/libncurses.dylib"
  '';

  buildPhase = stdenv.lib.optionalString stdenv.isDarwin "make -f Makefile.mac";
  buildInputs = [ libuuid popt icu ncurses ];

  installPhase = ''
    mkdir -p $out/sbin
    mkdir -p $out/share/man/man8
    for prog in gdisk sgdisk fixparts cgdisk
    do
        install -v -m755 $prog $out/sbin
        install -v -m644 $prog.8 $out/share/man/man8
    done
  '';

  meta = with stdenv.lib; {
    inherit version;
    description = "Set of text-mode partitioning tools for Globally Unique Identifier (GUID) Partition Table (GPT) disks";
    license = licenses.gpl2;
    homepage = http://www.rodsbooks.com/gdisk/;
    maintainers = with maintainers; [ nckx ];
    platforms = platforms.all;
  };
}
