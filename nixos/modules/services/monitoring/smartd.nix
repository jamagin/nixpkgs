{ config, lib, pkgs, ... }:

with lib;

let

  host = config.networking.hostName or "unknown"
       + optionalString (config.networking.domain != null) ".${config.networking.domain}";

  cfg = config.services.smartd;

  nm = cfg.notifications.mail;
  nw = cfg.notifications.wall;
  nx = cfg.notifications.x11;

  smartdNotify = pkgs.writeScript "smartd-notify.sh" ''
    #! ${pkgs.stdenv.shell}
    ${optionalString nm.enable ''
      {
      cat << EOF
      From: smartd on ${host} <root>
      To: undisclosed-recipients:;
      Subject: SMART error on $SMARTD_DEVICESTRING: $SMARTD_FAILTYPE

      $SMARTD_FULLMESSAGE
      EOF

      ${pkgs.smartmontools}/sbin/smartctl -a -d "$SMARTD_DEVICETYPE" "$SMARTD_DEVICE"
      } | ${nm.mailer} -i "${nm.recipient}"
    ''}
    ${optionalString nw.enable ''
      {
      cat << EOF
      Problem detected with disk: $SMARTD_DEVICESTRING
      Warning message from smartd is:

      $SMARTD_MESSAGE
      EOF
      } | ${pkgs.utillinux}/bin/wall 2>/dev/null
    ''}
    ${optionalString nx.enable ''
      export DISPLAY=${nx.display}
      {
      cat << EOF
      Problem detected with disk: $SMARTD_DEVICESTRING
      Warning message from smartd is:

      $SMARTD_FULLMESSAGE
      EOF
      } | ${pkgs.xorg.xmessage}/bin/xmessage -file - 2>/dev/null &
    ''}
  '';

  notifyOpts = optionalString (nm.enable || nw.enable || nx.enable)
    ("-m <nomailer> -M exec ${smartdNotify} " + optionalString cfg.notifications.test "-M test ");

  smartdConf = pkgs.writeText "smartd.conf" ''
    # Autogenerated smartd startup config file
    DEFAULT ${notifyOpts}${cfg.defaults.monitored}

    ${concatMapStringsSep "\n" (d: "${d.device} ${d.options}") cfg.devices}

    ${optionalString cfg.autodetect
       "DEVICESCAN ${notifyOpts}${cfg.defaults.autodetected}"}
  '';

  smartdOpts = { name, ... }: {

    options = {

      device = mkOption {
        example = "/dev/sda";
        type = types.str;
        description = "Location of the device.";
      };

      options = mkOption {
        default = "";
        example = "-d sat";
        type = types.separatedString " ";
        description = "Options that determine how smartd monitors the device.";
      };

    };

  };

in

{
  ###### interface

  options = {

    services.smartd = {

      enable = mkEnableOption "smartd daemon from <literal>smartmontools</literal> package";

      autodetect = mkOption {
        default = true;
        type = types.bool;
        description = ''
          Whenever smartd should monitor all devices connected to the
          machine at the time it's being started (the default).

          Set to false to monitor the devices listed in
          <option>services.smartd.devices</option> only.
        '';
      };

      notifications = {

        mail = {
          enable = mkOption {
            default = config.services.mail.sendmailSetuidWrapper != null;
            type = types.bool;
            description = "Whenever to send e-mail notifications.";
          };

          recipient = mkOption {
            default = "root";
            type = types.str;
            description = "Recipient of the notification messages.";
          };

          mailer = mkOption {
            default = "/var/permissions-wrappers/sendmail";
            type = types.path;
            description = ''
              Sendmail-compatible binary to be used to send the messages.

              You should probably enable
              <option>services.postfix</option> or some other MTA for
              this to work.
            '';
          };
        };

        wall = {
          enable = mkOption {
            default = true;
            type = types.bool;
            description = "Whenever to send wall notifications to all users.";
          };
        };

        x11 = {
          enable = mkOption {
            default = config.services.xserver.enable;
            type = types.bool;
            description = "Whenever to send X11 xmessage notifications.";
          };

          display = mkOption {
            default = ":${toString config.services.xserver.display}";
            type = types.str;
            description = "DISPLAY to send X11 notifications to.";
          };
        };

        test = mkOption {
          default = false;
          type = types.bool;
          description = "Whenever to send a test notification on startup.";
        };

      };

      defaults = {
        monitored = mkOption {
          default = "-a";
          type = types.separatedString " ";
          example = "-a -o on -s (S/../.././02|L/../../7/04)";
          description = ''
            Common default options for explicitly monitored (listed in
            <option>services.smartd.devices</option>) devices.

            The default value turns on monitoring of all the things (see
            <literal>man 5 smartd.conf</literal>).

            The example also turns on SMART Automatic Offline Testing on
            startup, and schedules short self-tests daily, and long
            self-tests weekly.
          '';
        };

        autodetected = mkOption {
          default = cfg.defaults.monitored;
          type = types.separatedString " ";
          description = ''
            Like <option>services.smartd.defaults.monitored</option>, but for the
            autodetected devices.
          '';
        };
      };

      devices = mkOption {
        default = [];
        example = [ { device = "/dev/sda"; } { device = "/dev/sdb"; options = "-d sat"; } ];
        type = types.listOf types.optionSet;
        options = [ smartdOpts ];
        description = "List of devices to monitor.";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    assertions = [ {
      assertion = cfg.autodetect || cfg.devices != [];
      message = "smartd can't run with both disabled autodetect and an empty list of devices to monitor.";
    } ];

    systemd.services.smartd = {
      description = "S.M.A.R.T. Daemon";

      wantedBy = [ "multi-user.target" ];

      path = [ pkgs.nettools ]; # for hostname and dnsdomanname calls in smartd

      serviceConfig.ExecStart = "${pkgs.smartmontools}/sbin/smartd --no-fork --configfile=${smartdConf}";
    };

  };

}
