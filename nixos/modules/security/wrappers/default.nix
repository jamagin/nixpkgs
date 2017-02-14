{ config, lib, pkgs, ... }:
let

  inherit (config.security) wrapperDir wrappers setuidPrograms;

  programs =
    (lib.mapAttrsToList
      (n: v: (if v ? "program" then v else v // {program=n;}))
      wrappers);

  securityWrapper = pkgs.stdenv.mkDerivation {
    name            = "security-wrapper";
    phases          = [ "installPhase" "fixupPhase" ];
    buildInputs     = [ pkgs.libcap pkgs.libcap_ng pkgs.linuxHeaders ];
    hardeningEnable = [ "pie" ];
    installPhase = ''
      mkdir -p $out/bin
      parentWrapperDir=$(dirname ${wrapperDir})
      gcc -Wall -O2 -DWRAPPER_DIR=\"$parentWrapperDir\" \
          -lcap-ng -lcap ${./wrapper.c} -o $out/bin/security-wrapper
    '';
  };

  ###### Activation script for the setcap wrappers
  mkSetcapProgram =
    { program
    , capabilities
    , source
    , owner  ? "nobody"
    , group  ? "nogroup"
    , ...
    }:
    assert (lib.versionAtLeast (lib.getVersion config.boot.kernelPackages.kernel) "4.3");
    ''
      cp ${securityWrapper}/bin/security-wrapper $wrapperDir/${program}
      echo -n "${source}" > $wrapperDir/${program}.real

      # Prevent races
      chmod 0000 $wrapperDir/${program}
      chown ${owner}.${group} $wrapperDir/${program}

      # Set desired capabilities on the file plus cap_setpcap so
      # the wrapper program can elevate the capabilities set on
      # its file into the Ambient set.
      ${pkgs.libcap.out}/bin/setcap "cap_setpcap,${capabilities}" $wrapperDir/${program}

      # Set the executable bit
      chmod u+rx,g+x,o+x $wrapperDir/${program}
    '';

  ###### Activation script for the setuid wrappers
  mkSetuidProgram =
    { program
    , source
    , owner  ? "nobody"
    , group  ? "nogroup"
    , setuid ? false
    , setgid ? false
    , permissions ? "u+rx,g+x,o+x"
    , ...
    }:
    ''
      cp ${securityWrapper}/bin/security-wrapper $wrapperDir/${program}
      echo -n "${source}" > $wrapperDir/${program}.real

      # Prevent races
      chmod 0000 $wrapperDir/${program}
      chown ${owner}.${group} $wrapperDir/${program}

      chmod "u${if setuid then "+" else "-"}s,g${if setgid then "+" else "-"}s,${permissions}" $wrapperDir/${program}
    '';

  mkWrappedPrograms =
    builtins.map
      (s: if (s ? "capabilities")
          then mkSetcapProgram s
          else if 
             (s ? "setuid"  && s.setuid  == true) ||
             (s ? "setguid" && s.setguid == true) ||
             (s ? "permissions")
          then mkSetuidProgram s
          else mkSetuidProgram
                 ({ owner  = "root";
                    group  = "root";
                    setuid = true;
                    setgid = false;
                    permissions = "u+rx,g+x,o+x";
                  } // s)
      ) programs;
in
{

  ###### interface

  options = {
    security.wrappers = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      example = {
        sendmail.source = "/nix/store/.../bin/sendmail";
        ping = {
          source  = "${pkgs.iputils.out}/bin/ping";
          owner   = "nobody";
          group   = "nogroup";
          capabilities = "cap_net_raw+ep";
        };
      };
      description = ''
        This option allows the ownership and permissions on the setuid
        wrappers for specific programs to be overridden from the
        default (setuid root, but not setgid root).

        Additionally, this option can set capabilities on a wrapper
        program that propagates those capabilities down to the
        wrapped, real program.

        The <literal>program</literal> attribute is the name of the
        program to be wrapped. If no <literal>source</literal>
        attribute is provided, specifying the absolute path to the
        program, then the program will be searched for in the path
        environment variable.

        NOTE: cap_setpcap, which is required for the wrapper program
        to be able to raise caps into the Ambient set is NOT raised to
        the Ambient set so that the real program cannot modify its own
        capabilities!! This may be too restrictive for cases in which
        the real program needs cap_setpcap but it at least leans on
        the side security paranoid vs. too relaxed.
      '';
    };

    security.wrapperDir = lib.mkOption {
      type        = lib.types.path;
      default     = "/run/wrappers/bin";
      internal    = true;
      description = ''
        This option defines the path to the wrapper programs. It
        should not be overriden.
      '';
    };
  };

  ###### implementation
  config = {

    security.wrappers.fusermount.source = "${pkgs.fuse}/bin/fusermount";

    # Make sure our wrapperDir exports to the PATH env variable when
    # initializing the shell
    environment.extraInit = ''
      # Wrappers override other bin directories.
      export PATH="${wrapperDir}:$PATH"
    '';

    ###### setcap activation script
    system.activationScripts.wrappers =
      lib.stringAfter [ "users" ]
        ''
          # Look in the system path and in the default profile for
          # programs to be wrapped.
          WRAPPER_PATH=${config.system.path}/bin:${config.system.path}/sbin

          # Remove the old /var/setuid-wrappers path from the system...
          #
          # TDOO: this is only necessary for ugprades 16.09 => 17.x;
          # this conditional removal block needs to be removed after
          # the release.
          if [ -d ${config.security.old-wrapperDir} ]; then
            rm -rf ${config.security.old-wrapperDir}
          fi

          # Remove the old /run/setuid-wrappers-dir path from the
          # system as well...
          #
          # TDOO: this is only necessary for ugprades 16.09 => 17.x;
          # this conditional removal block needs to be removed after
          # the release.
          if [ -d /run/setuid-wrapper-dirs ]; then
            rm -rf /run/setuid-wrapper-dirs
          fi

          # Get the "/run/wrappers" path, we want to place the tmpdirs
          # for the wrappers there
          parentWrapperDir="$(dirname ${wrapperDir})"

          mkdir -p "$parentWrapperDir"
          wrapperDir=$(mktemp --directory --tmpdir="$parentWrapperDir" wrappers.XXXXXXXXXX)
          chmod a+rx $wrapperDir

          ${lib.concatStringsSep "\n" mkWrappedPrograms}

          if [ -L ${wrapperDir} ]; then
            # Atomically replace the symlink
            # See https://axialcorps.com/2013/07/03/atomically-replacing-files-and-directories/
            old=$(readlink -f ${wrapperDir})
            ln --symbolic --force --no-dereference $wrapperDir ${wrapperDir}-tmp
            mv --no-target-directory ${wrapperDir}-tmp ${wrapperDir}
            rm --force --recursive $old
          elif [ -d ${wrapperDir} ]; then
            # Compatibility with old state, just remove the folder and symlink
            rm -f ${wrapperDir}/*
            # if it happens to be a tmpfs
            ${pkgs.utillinux}/bin/umount ${wrapperDir} || true
            rm -d ${wrapperDir}
            ln -d --symbolic $wrapperDir ${wrapperDir}
          else
            # For initial setup
            ln --symbolic $wrapperDir ${wrapperDir}
          fi
        '';
  };
}
