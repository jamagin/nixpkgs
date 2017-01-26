{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.locate;
in {
  options.services.locate = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, NixOS will periodically update the database of
        files used by the <command>locate</command> command.
      '';
    };

    locate = mkOption {
      type = types.package;
      default = pkgs.findutils;
      defaultText = "pkgs.findutils";
      example = "pkgs.mlocate";
      description = ''
        The locate implementation to use
      '';
    };

    interval = mkOption {
      type = types.str;
      default = "02:15";
      example = "hourly";
      description = ''
        Update the locate database at this interval. Updates by
        default at 2:15 AM every day.

        The format is described in
        <citerefentry><refentrytitle>systemd.time</refentrytitle>
        <manvolnum>7</manvolnum></citerefentry>.
      '';
    };

    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Extra flags to pass to <command>updatedb</command>.
      '';
    };

    output = mkOption {
      type = types.path;
      default = "/var/cache/locatedb";
      description = ''
        The database file to build.
      '';
    };

    localuser = mkOption {
      type = types.nullOr types.str;
      default = "nobody";
      description = ''
        The user to search non-network directories as, using
        <command>su</command>.
      '';
    };

    includeStore = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to include <filename>/nix/store</filename> in the locate database.
      '';
    };
  };

  config = {
    systemd.services.update-locatedb =
      { description = "Update Locate Database";
        path  = [ pkgs.su ];
        script =
          ''
            mkdir -m 0755 -p $(dirname ${toString cfg.output})
            exec ${cfg.locate}/bin/updatedb \
              ${optionalString (cfg.localuser != null) ''--localuser=${cfg.localuser}''} \
              ${optionalString (!cfg.includeStore) "--prunepaths='/nix/store'"} \
              --output=${toString cfg.output} ${concatStringsSep " " cfg.extraFlags}
          '';
        serviceConfig.Nice = 19;
        serviceConfig.IOSchedulingClass = "idle";
        serviceConfig.PrivateTmp = "yes";
        serviceConfig.PrivateNetwork = "yes";
        serviceConfig.NoNewPrivileges = "yes";
        serviceConfig.ReadOnlyDirectories = "/";
        serviceConfig.ReadWriteDirectories = dirOf cfg.output;
      };

    systemd.timers.update-locatedb = mkIf cfg.enable
      { description = "Update timer for locate database";
        partOf      = [ "update-locatedb.service" ];
        wantedBy    = [ "timers.target" ];
        timerConfig.OnCalendar = cfg.interval;
      };
  };
}
