{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.userModules.gtk;
in
{
  options.userModules.gtk = {
    enable = mkEnableOption "GTK";
  };
  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      # Needed on Plasma
      # https://github.com/nix-community/home-manager/issues/6188
      gtk2.force = true;
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };
}
