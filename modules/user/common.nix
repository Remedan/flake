{ config, lib, pkgs, ... }:
let
  inherit (lib) mkDefault;
in
{
  config = {
    home.stateVersion = "26.05";
    programs.home-manager.enable = true;
    xdg.userDirs.enable = true;
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
    programs.nix-index.enable = mkDefault true;
    programs.yazi.enable = mkDefault true;
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
      nextcloud.enable = mkDefault true;
      vscodium.enable = mkDefault true;
    };
  };
}
