{ isoFile
, productKey
}:

let
  inherit (import <nixpkgs> {}) lib stdenv runCommand openssh qemu;

  bootstrapAfterLogin = runCommand "bootstrap.sh" {} ''
    cat > "$out" <<EOF
    mkdir -p ~/.ssh
    cat > ~/.ssh/authorized_keys <<PUBKEY
    $(cat "${cygwinSshKey}/key.pub")
    PUBKEY
    ssh-host-config -y -c 'binmode ntsec' -w dummy

    net use S: '\\192.168.0.2\nixstore'
    mkdir -p /nix/store
    echo "/cygdrives/s /nix/store none bind 0 0" >> /etc/fstab
    shutdown -s now
    EOF
  '';

  cygwinSshKey = stdenv.mkDerivation {
    name = "snakeoil-ssh-cygwin";
    buildCommand = ''
      ensureDir "$out"
      ${openssh}/bin/ssh-keygen -t ecdsa -f "$out/key" -N ""
    '';
  };

  sshKey = "${cygwinSshKey}/key";

  packages = [ "openssh" "shutdown" ];

  instfloppy = import ./unattended-image.nix {
    cygwinPackages = packages;
    inherit productKey;
  };

  cygiso = import ../cygwin-iso {
    inherit packages;
    extraContents = lib.singleton {
      source = bootstrapAfterLogin;
      target = "bootstrap.sh";
    };
  };

  installController = import ../controller {
    inherit sshKey;
    installMode = true;
    qemuArgs = [
      "-boot order=c,once=d"
      "-drive file=${instfloppy},readonly,index=0,if=floppy"
      "-drive file=winvm.img,index=0,media=disk"
      "-drive file=${isoFile},index=1,media=cdrom"
      "-drive file=${cygiso}/iso/cd.iso,index=2,media=cdrom"
    ];
  };

in stdenv.mkDerivation {
  name = "cygwin-base-vm";
  buildCommand = ''
    ${qemu}/bin/qemu-img create -f qcow2 winvm.img 2G
    ${installController}
    ensureDir "$out"
    cp winvm.img "$out/disk.img"
  '';
  passthru = {
    inherit sshKey;
  };
}
