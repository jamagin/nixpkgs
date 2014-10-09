{ stdenv, fetchurl, libpcap, bash }:

stdenv.mkDerivation rec {
  name    = "p0f-${version}";
  version = "3.07b";

  src = fetchurl {
    url    = "http://lcamtuf.coredump.cx/p0f3/releases/${name}.tgz";
    sha256 = "18hbkwvh8maswhka0cyq0rwznz8yacnf4h1jmvb8krz0695rmz2w";
  };

  buildInputs = [ libpcap ];

  buildPhase = ''
    substituteInPlace config.h --replace "p0f.fp" "$out/etc/p0f.fp"
    substituteInPlace build.sh --replace "/bin/bash" "${bash}/bin/bash"
    ./build.sh
    cd tools && make && cd ..
  '';

  installPhase = ''
    mkdir -p $out/sbin $out/etc

    cp ./p0f                $out/sbin
    cp ./p0f.fp             $out/etc

    cp ./tools/p0f-client   $out/sbin
    cp ./tools/p0f-sendsyn  $out/sbin
    cp ./tools/p0f-sendsyn6 $out/sbin
  '';

  meta = {
    description = "Passive network reconnaissance and fingerprinting tool";
    homepage    = "http://lcamtuf.coredump.cx/p0f3/";
    license     = stdenv.lib.licenses.lgpl21;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
