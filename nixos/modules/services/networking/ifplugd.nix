{pkgs, config, ...}:

with pkgs.lib;

let

  inherit (pkgs) ifplugd;

  cfg = config.networking.interfaceMonitor;

  # The ifplugd action script, which is called whenever the link
  # status changes (i.e., a cable is plugged in or unplugged).  We do
  # nothing when a cable is unplugged.  When a cable is plugged in, we
  # restart dhclient, which will hopefully give us a new IP address
  # if appropriate.
  plugScript = pkgs.writeScript "ifplugd.action"
    ''
      #! ${pkgs.stdenv.shell}
      iface="$1"
      status="$2"
      ${cfg.commands}
    '';

in

{

  ###### interface

  options = {

    networking.interfaceMonitor.enable = mkOption {
      default = false;
      description = ''
        If <literal>true</literal>, monitor Ethernet interfaces for
        cables being plugged in or unplugged.  When this occurs, the
        <command>dhclient</command> service is restarted to
        automatically obtain a new IP address.  This is useful for
        roaming users (laptops).
      '';
    };

    networking.interfaceMonitor.beep = mkOption {
      default = false;
      description = ''
        If <literal>true</literal>, beep when an Ethernet cable is
        plugged in or unplugged.
      '';
    };

    networking.interfaceMonitor.commands = mkOption {
      default = "";
      description = ''
        Shell commands to be executed when the link status of an
        interface changes.  On invocation, the shell variable
        <varname>iface</varname> contains the name of the interface,
        while the variable <varname>status</varname> contains either
        <literal>up</literal> or <literal>down</literal> to indicate
        the new status.
      '';
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    jobs.ifplugd =
      { description = "Network interface connectivity monitor";

        startOn = "started network-interfaces";
        stopOn = "stopping network-interfaces";

        exec =
          ''
            ${ifplugd}/sbin/ifplugd --no-daemon --no-startup --no-shutdown \
              ${if config.networking.interfaceMonitor.beep then "" else "--no-beep"} \
              --run ${plugScript}
          '';
      };

    environment.systemPackages = [ ifplugd ];

  };

}
