# Provide a basic configuration for installation devices like CDs.
{ config, lib, ... }:

with lib;

{
  imports =
    [ # Enable devices which are usually scanned, because we don't know the
      # target system.
      ../installer/scan/detected.nix
      ../installer/scan/not-detected.nix

      # Allow "nixos-rebuild" to work properly by providing
      # /etc/nixos/configuration.nix.
      ./clone-config.nix
    ];

  config = {

    # Show the manual.
    services.nixosManual.showManual = true;

    # Let the user play Rogue on TTY 8 during the installation.
    services.rogue.enable = true;

    # Disable some other stuff we don't need.
    security.sudo.enable = false;

    # Automatically log in at the virtual consoles.
    services.mingetty.autologinUser = "root";

    # Some more help text.
    services.mingetty.helpLine =
      ''

        The "root" account has an empty password.  ${
          optionalString config.services.xserver.enable
            "Type `start display-manager' to\nstart the graphical user interface."}
      '';

    # Allow sshd to be started manually through "start sshd".
    services.openssh.enable = true;
    systemd.services.sshd.wantedBy = mkOverride 50 [];

    # Enable wpa_supplicant, but don't start it by default.
    networking.wireless.enable = true;
    jobs.wpa_supplicant.startOn = mkOverride 50 "";

    # Tell the Nix evaluator to garbage collect more aggressively.
    # This is desirable in memory-constrained environments that don't
    # (yet) have swap set up.
    environment.variables.GC_INITIAL_HEAP_SIZE = "100000";

  };
}
