# Provide an initial copy of the NixOS channel so that the user
# doesn't need to run "nix-channel --update" first.

{ config, lib, pkgs, ... }:

with lib;

let
  # Do not include these things:
  #   - The '.git' directory
  #   - Result symlinks from nix-build ('result', 'result-2', 'result-bin', ...)
  #   - VIM/Emacs swap/backup files ('.swp', '.swo', '.foo.swp', 'foo~', ...)
  filterFn = path: type: let basename = baseNameOf (toString path); in
    if type == "directory" then basename != ".git"
    else if type == "symlink" then builtins.match "^result(|-.*)$" basename == null
    else builtins.match "^((|\..*)\.sw[a-z]|.*~)$" basename == null;

  nixpkgs = builtins.filterSource filterFn pkgs.path;

  # We need a copy of the Nix expressions for Nixpkgs and NixOS on the
  # CD.  These are installed into the "nixos" channel of the root
  # user, as expected by nixos-rebuild/nixos-install. FIXME: merge
  # with make-channel.nix.
  channelSources = pkgs.runCommand "nixos-${config.system.nixosVersion}"
    { }
    ''
      mkdir -p $out
      cp -prd ${nixpkgs} $out/nixos
      chmod -R u+w $out/nixos
      if [ ! -e $out/nixos/nixpkgs ]; then
        ln -s . $out/nixos/nixpkgs
      fi
      echo -n ${config.system.nixosVersionSuffix} > $out/nixos/.version-suffix
    '';

in

{
  # Provide the NixOS/Nixpkgs sources in /etc/nixos.  This is required
  # for nixos-install.
  boot.postBootCommands = mkAfter
    ''
      if ! [ -e /var/lib/nixos/did-channel-init ]; then
        echo "unpacking the NixOS/Nixpkgs sources..."
        mkdir -p /nix/var/nix/profiles/per-user/root
        ${config.nix.package.out}/bin/nix-env -p /nix/var/nix/profiles/per-user/root/channels \
          -i ${channelSources} --quiet --option build-use-substitutes false
        mkdir -m 0700 -p /root/.nix-defexpr
        ln -s /nix/var/nix/profiles/per-user/root/channels /root/.nix-defexpr/channels
        mkdir -m 0755 -p /var/lib/nixos
        touch /var/lib/nixos/did-channel-init
      fi
    '';
}
