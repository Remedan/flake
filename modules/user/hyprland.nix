{ config, lib, pkgs, osConfig ? null, ... }:
let
  cfg = config.userModules.hyprland;
in
{
  options.userModules.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = osConfig != null && osConfig.systemModules.base.desktopEnvironment == "Hyprland";
    };
  };
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false; # Replaced by UWSM
    };
  };
}
