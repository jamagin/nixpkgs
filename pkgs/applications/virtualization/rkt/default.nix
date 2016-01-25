{ stdenv, lib, autoreconfHook, acl, go, file, git, wget, gnupg1, squashfsTools,
  cpio, fetchurl, fetchFromGitHub, iptables, systemd, makeWrapper }:

let
  coreosImageRelease = "794.1.0";
  coreosImageSystemdVersion = "222";

  # TODO: track https://github.com/coreos/rkt/issues/1758 to allow "host" flavor.
  stage1Flavours = [ "coreos" "fly" "host" ];

in stdenv.mkDerivation rec {
  version = "0.15.0";
  name = "rkt-${version}";
  BUILDDIR="build-${name}";

  src = fetchFromGitHub {
      rev = "v${version}";
      owner = "coreos";
      repo = "rkt";
      sha256 = "1pw14r38p8sdkma37xx0yy3zx5yxqc12zj35anmlbmrgw4vdgavf";
  };

  stage1BaseImage = fetchurl {
    url = "http://alpha.release.core-os.net/amd64-usr/${coreosImageRelease}/coreos_production_pxe_image.cpio.gz";
    sha256 = "05nzl3av6cawr8v203a8c95c443g6h1nfy2n4jmgvn0j4iyy44ym";
  };

  buildInputs = [
    autoreconfHook go file git wget gnupg1 squashfsTools cpio acl systemd
    makeWrapper
  ];

  preConfigure = ''
    ./autogen.sh
    configureFlagsArray=(
      --with-stage1-flavors=${builtins.concatStringsSep "," stage1Flavours}
      ${if lib.findFirst (p: p == "coreos") null stage1Flavours != null then "
      --with-coreos-local-pxe-image-path=${stage1BaseImage}
      --with-coreos-local-pxe-image-systemd-version=v${coreosImageSystemdVersion}
      " else "" }
    );
  '';

  preBuild = ''
    export BUILDDIR
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -Rv $BUILDDIR/bin/* $out/bin
    wrapProgram $out/bin/rkt \
      --prefix LD_LIBRARY_PATH : ${systemd}/lib \
      --prefix PATH : ${iptables}/bin
  '';

  meta = with lib; {
    description = "A fast, composable, and secure App Container runtime for Linux";
    homepage = https://github.com/coreos/rkt;
    license = licenses.asl20;
    maintainers = with maintainers; [ ragge steveej ];
    platforms = [ "x86_64-linux" ];
  };
}
