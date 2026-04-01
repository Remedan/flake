{ config, lib, pkgs, ... }:
with lib;
{
  config = mkMerge [
    {
      home.stateVersion = "25.11";
      programs.home-manager.enable = true;
      xdg.userDirs.enable = true;
      nix = {
        package = mkDefault pkgs.nix;
        settings.experimental-features = [ "nix-command" "flakes" ];
      };
      programs.nix-index.enable = mkDefault true;
      programs.yazi = {
        enable = mkDefault true;
        shellWrapperName = "y";
      };
      programs.zellij.enable = mkDefault true;
      userModules = {
        packages.enable = mkDefault true;
        shell.enable = mkDefault true;
        kitty.enable = mkDefault true;
        emacs.enable = mkDefault true;
        fonts.enable = mkDefault true;
        gtk.enable = mkDefault true;
        ssh.enable = mkDefault true;
        git.enable = mkDefault true;
        virt-manager.enable = mkDefault true;
        flatpak.enable = mkDefault true;
        ranger.enable = mkDefault true;
        nextcloud.enable = mkDefault true;
        vscodium.enable = mkDefault true;
      };
    }
  ];
}
