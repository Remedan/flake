{ config, lib, pkgs, osConfig ? null, ... }:
with lib;
let
  cfg = config.userModules.hyprland;
in
{
  options.userModules.hyprland = {
    enable = mkOption {
      type = types.bool;
      default = osConfig != null && osConfig.systemModules.base.desktopEnvironment == "Hyprland";
    };
  };
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false; # Replaced by UWSM
    };
  };
}
