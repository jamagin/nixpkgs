# NixOS module for kippo honeypot ssh server
# See all the options for configuration details.
#
# Default port is 2222. Recommend using something like this for port redirection to default SSH port:
# networking.firewall.extraCommands = ''
#      iptables -t nat -A PREROUTING -i IN_IFACE -p tcp --dport 22 -j REDIRECT --to-port 2222'';
#
# Lastly: use this service at your own risk. I am working on a way to run this inside a VM.
{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.kippo;
in
rec {
  options = {
    services.kippo = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''Enable the kippo honeypot ssh server.'';
      };
      port = mkOption {
        default = 2222;
        type = types.int;
        description = ''TCP port number for kippo to bind to.'';
      };
      hostname = mkOption {
        default = "nas3";
        type = types.string;
        description = ''Hostname for kippo to present to SSH login'';
      };
      varPath = mkOption {
        default = "/var/lib/kippo";
        type = types.string;
        description = ''Path of read/write files needed for operation and configuration.'';
      };
      logPath = mkOption {
        default = "/var/log/kippo";
        type = types.string;
        description = ''Path of log files needed for operation and configuration.'';
      };
      pidPath = mkOption {
        default = "/run/kippo";
        type = types.string;
        description = ''Path of pid files needed for operation.'';
      };
      extraConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''Extra verbatim configuration added to the end of kippo.cfg.'';
      };
    };

  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs.pythonPackages; [
      python pkgs.kippo.twisted pycrypto pyasn1 ];

    environment.etc."kippo.cfg".text = ''
        # Automatically generated by NixOS.
        # See ${pkgs.kippo}/src/kippo.cfg for details.
        [honeypot]
        log_path = ${cfg.logPath}
        download_path = ${cfg.logPath}/dl
        filesystem_file = ${cfg.varPath}/honeyfs
        filesystem_file = ${cfg.varPath}/fs.pickle
        data_path = ${cfg.varPath}/data
        txtcmds_path = ${cfg.varPath}/txtcmds
        public_key = ${cfg.varPath}/keys/public.key
        private_key = ${cfg.varPath}/keys/private.key
        ssh_port = ${toString cfg.port}
        hostname = ${cfg.hostname}
        ${cfg.extraConfig}
    '';

    users.extraUsers = singleton {
      name = "kippo";
      description = "kippo web server privilege separation user";
      uid = 108; # why does config.ids.uids.kippo give an error?
    };
    users.extraGroups = singleton { name = "kippo";gid=108; };

    systemd.services.kippo = with pkgs; {
      description = "Kippo Web Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment.PYTHONPATH = "${pkgs.kippo}/src/:${pkgs.pythonPackages.pycrypto}/lib/python2.7/site-packages/:${pkgs.pythonPackages.pyasn1}/lib/python2.7/site-packages/:${pkgs.pythonPackages.python}/lib/python2.7/site-packages/:${pkgs.kippo.twisted}/lib/python2.7/site-packages/:.";
      preStart = ''
        if [ ! -d ${cfg.varPath}/ ] ; then
            mkdir -p ${cfg.logPath}/tty
            mkdir -p ${cfg.logPath}/dl
            mkdir -p ${cfg.varPath}/keys
            cp ${pkgs.kippo}/src/honeyfs ${cfg.varPath} -r
            cp ${pkgs.kippo}/src/fs.pickle ${cfg.varPath}/fs.pickle
            cp ${pkgs.kippo}/src/data ${cfg.varPath} -r
            cp ${pkgs.kippo}/src/txtcmds ${cfg.varPath} -r

            chmod u+rw ${cfg.varPath} -R
            chown kippo.kippo ${cfg.varPath} -R
            chown kippo.kippo ${cfg.logPath} -R
            chmod u+rw ${cfg.logPath} -R
        fi
        if [ ! -d ${cfg.pidPath}/ ] ; then
            mkdir -p ${cfg.pidPath}
            chmod u+rw ${cfg.pidPath}
            chown kippo.kippo ${cfg.pidPath}
        fi
      '';

      serviceConfig.ExecStart = "${pkgs.kippo.twisted}/bin/twistd -y ${pkgs.kippo}/src/kippo.tac --syslog --rundir=${cfg.varPath}/ --pidfile=${cfg.pidPath}/kippo.pid --prefix=kippo -n";
      serviceConfig.PermissionsStartOnly = true;
      serviceConfig.User = "kippo"; 
      serviceConfig.Group = "kippo"; 
    };
};
}


