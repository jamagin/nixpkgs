{ stdenv, fetchurl, zlib, openssl, perl, libedit, pkgconfig, pam, curl
, etcDir ? null
, hpnSupport ? false
}:

let

  # Ugly download
  hpnSrc = stdenv.mkDerivation {
    name = "openssh-6.1p1-hpn13v14.diff.gz";

    buildInputs = [ curl ];

    url = "http://www.psc.edu/index.php/component/remository/HPN-SSH/OpenSSH-6.1-Patches/HPN-SSH-Kitchen-Sink-Patch-for-OpenSSH-6.1/";

    phases = [ "installPhase" ];

    installPhase = ''
      URL2=$(curl -c cookies.jar "$url" | grep "window.location" |
        sed 's,.*\(http:/.*\)'"'"'},\1,')
      URL3=$(curl -b cookies.jar -c cookies.jar "$URL2" | grep "window.location" |
        sed 's,.*\(http:/.*\)'"'"'},\1,')
      curl -b cookies.jar "$URL3" > $out
    '';

    outputHashAlgo = "sha256";
    outputHash = "14das6lim6fxxnx887ssw76ywsbvx3s4q3n43afgh5rgvs4xmnnq";
  };

in

stdenv.mkDerivation rec {
  name = "openssh-6.1p1";

  src = fetchurl {
    url = "ftp://ftp.nl.uu.net/pub/OpenBSD/OpenSSH/portable/${name}.tar.gz";
    sha1 = "751c92c912310c3aa9cadc113e14458f843fc7b3";
  };

  prePatch = stdenv.lib.optionalString hpnSupport
    ''
      gunzip -c ${hpnSrc} | patch -p1
      export NIX_LDFLAGS="$NIX_LDFLAGS -lgcc_s"
    '';
    
  patches = [ ./locale_archive.patch ];

  buildNativeInptus = [ perl ];
  buildInputs = [ zlib openssl libedit pkgconfig pam ];

  # I set --disable-strip because later we strip anyway. And it fails to strip
  # properly when cross building.
  configureFlags =
    ''
      --with-mantype=man
      --with-libedit=yes
      --disable-strip
      ${if pam != null then "--with-pam" else "--without-pam"}
      ${if etcDir != null then "--sysconfdir=${etcDir}" else ""}
    '';

  preConfigure =
    ''
      configureFlags="$configureFlags --with-privsep-path=$out/empty"
      mkdir -p $out/empty
    '';

  postInstall =
    ''
      # Install ssh-copy-id, it's very useful.
      cp contrib/ssh-copy-id $out/bin/
      chmod +x $out/bin/ssh-copy-id
      cp contrib/ssh-copy-id.1 $out/share/man/man1/

      mkdir -p $out/etc/ssh
      cp moduli $out/etc/ssh/
    '';

  installTargets = "install-nosysconf";

  meta = {
    homepage = http://www.openssh.org/;
    description = "An implementation of the SSH protocol";
    license = "bsd";
  };
}
