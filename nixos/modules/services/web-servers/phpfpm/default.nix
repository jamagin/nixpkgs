{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.phpfpm;

  stateDir = "/run/phpfpm";

  mkPool = n: p: ''
    [${n}]
    listen = ${p.listen}
    ${p.extraConfig}
  '';

  cfgFile = pkgs.writeText "phpfpm.conf" ''
    [global]
    error_log = syslog
    daemonize = no
    ${cfg.extraConfig}

    ${concatStringsSep "\n" (mapAttrsToList mkPool cfg.pools)}

    ${concatStringsSep "\n" (mapAttrsToList (n: v: "[${n}]\n${v}") cfg.poolConfigs)}
  '';

  phpIni = pkgs.writeText "php.ini" ''
    ${readFile "${cfg.phpPackage}/etc/php.ini"}

    ${cfg.phpOptions}
  '';

in {

  options = {
    services.phpfpm = {
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration that should be put in the global section of
          the PHP-FPM configuration file. Do not specify the options
          <literal>error_log</literal> or
          <literal>daemonize</literal> here, since they are generated by
          NixOS.
        '';
      };

      phpPackage = mkOption {
        type = types.package;
        default = pkgs.php;
        defaultText = "pkgs.php";
        description = ''
          The PHP package to use for running the PHP-FPM service.
        '';
      };

      phpOptions = mkOption {
        type = types.lines;
        default = "";
        example =
          ''
            date.timezone = "CET"
          '';
        description =
          "Options appended to the PHP configuration file <filename>php.ini</filename>.";
      };

      poolConfigs = mkOption {
        default = {};
        type = types.attrsOf types.lines;
        example = literalExample ''
          { mypool = '''
              listen = /run/phpfpm/mypool
              user = nobody
              pm = dynamic
              pm.max_children = 75
              pm.start_servers = 10
              pm.min_spare_servers = 5
              pm.max_spare_servers = 20
              pm.max_requests = 500
            ''';
          }
        '';
        description = ''
          A mapping between PHP-FPM pool names and their configurations.
          See the documentation on <literal>php-fpm.conf</literal> for
          details on configuration directives. If no pools are defined,
          the phpfpm service is disabled.
        '';
      };

      pools = mkOption {
        type = types.attrsOf (types.submodule (import ./pool-options.nix {
          inherit lib;
        }));
        default = {};
        example = literalExample ''
         {
           mypool = {
             listen = "/path/to/unix/socket";
             extraConfig = '''
               user = nobody
               pm = dynamic
               pm.max_children = 75
               pm.start_servers = 10
               pm.min_spare_servers = 5
               pm.max_spare_servers = 20
               pm.max_requests = 500
             ''';
           }
         }'';
        description = ''
          PHP-FPM pools. If no pools or poolConfigs are defined, the PHP-FPM
          service is disabled.
        '';
      };
    };
  };

  config = mkIf (cfg.pools != {} || cfg.poolConfigs != {}) {

    systemd.services.phpfpm = {
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -p "${stateDir}"
      '';
      serviceConfig = {
        Type = "notify";
        ExecStart = "${cfg.phpPackage}/bin/php-fpm -y ${cfgFile} -c ${phpIni}";
      };
    };

  };
}
