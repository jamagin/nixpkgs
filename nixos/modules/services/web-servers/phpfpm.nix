{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.phpfpm;

  stateDir = "/run/phpfpm";

  pidFile = "${stateDir}/phpfpm.pid";

  cfgFile = pkgs.writeText "phpfpm.conf" ''
    [global]
    pid = ${pidFile}
    error_log = syslog
    daemonize = yes
    ${cfg.extraConfig}

    ${concatStringsSep "\n" (mapAttrsToList (n: v: "[${n}]\n${v}") cfg.poolConfigs)}
  '';

in {

  options = {
    services.phpfpm = {
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration that should be put in the global section of
          the PHP FPM configuration file. Do not specify the options
          <literal>pid</literal>, <literal>error_log</literal> or
          <literal>daemonize</literal> here, since they are generated by
          NixOS.
        '';
      };

      phpPackage = mkOption {
        default = pkgs.php;
        description = ''
          The PHP package to use for running the FPM service.
        '';
      };

      phpIni = mkOption {
        type = types.path;
        description = "PHP configuration file to use.";
      };

      poolConfigs = mkOption {
        type = types.attrsOf types.lines;
        default = {};
        example = {
          mypool = ''
            listen = /run/phpfpm/mypool
            user = nobody
            pm = dynamic
            pm.max_children = 75
            pm.start_servers = 10
            pm.min_spare_servers = 5
            pm.max_spare_servers = 20
            pm.max_requests = 500
          '';
        };
        description = ''
          A mapping between PHP FPM pool names and their configurations.
          See the documentation on <literal>php-fpm.conf</literal> for
          details on configuration directives. If no pools are defined,
          the phpfpm service is disabled.
        '';
      };
    };
  };

  config = mkIf (cfg.poolConfigs != {}) {

    systemd.services.phpfpm = {
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -p "${stateDir}"
      '';
      serviceConfig = {
        ExecStart = "${cfg.phpPackage}/sbin/php-fpm -y ${cfgFile} -c ${cfg.phpIni}";
        PIDFile = pidFile;
      };
    };

    services.phpfpm.phpIni = mkDefault "${cfg.phpPackage}/etc/php-recommended.ini";

  };
}
