{ config, lib, pkgs, ... }:

with lib;

let
  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.maxx;
in {
  options.services.xserver.desktopManager.maxx = {
    enable = mkEnableOption "MaXX desktop environment";
  };

  config = mkIf (xcfg.enable && cfg.enable) {
    environment.systemPackages = [ pkgs.maxx ];

    services.xserver.desktopManager.session = [
    { name = "MaXX";
      start = ''
        exec ${pkgs.maxx}/opt/MaXX/etc/skel/Xsession.dt
      '';
    }];
  };

  meta.maintainers = [ maintainers.gnidorah ];
}
