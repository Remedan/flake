{ config, lib, pkgs, ... }:
with lib;
{
  config = mkMerge [
    {
      home.stateVersion = "24.11";
      programs.home-manager.enable = true;
      xdg.userDirs.enable = true;
      nix = {
        package = pkgs.nix;
        settings.experimental-features = [ "nix-command" "flakes" ];
      };
      programs.nix-index.enable = true;
      user-modules = {
        packages.enable = mkDefault true;
        shell.enable = mkDefault true;
        kitty.enable = mkDefault true;
        emacs.enable = mkDefault true;
        music.enable = mkDefault true;
        fonts.enable = mkDefault true;
        gtk.enable = mkDefault true;
        ssh.enable = mkDefault true;
        git.enable = mkDefault true;
        gnome.enable = mkDefault true;
        virt-manager.enable = mkDefault true;
        gpg.enable = mkDefault true;
        flatpak.enable = mkDefault true;
        ranger.enable = mkDefault true;
      };
    }
  ];
}
