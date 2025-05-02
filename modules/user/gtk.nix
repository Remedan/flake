{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.gtk;
in
{
  options.user-modules.gtk = {
    enable = mkEnableOption "GTK";
  };
  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };
}
