{ config, lib, pkgs, osConfig ? null, ... }:
with lib;
let
  cfg = config.userModules.plasma;
in
{
  options.userModules.plasma = {
    enable = mkOption {
      type = types.bool;
      default = osConfig != null && osConfig.systemModules.common.desktopEnvironment == "KDE";
    };
  };
  config = mkIf cfg.enable {
    programs.plasma = {
      enable = true;
      shortcuts = {
        "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "Meta+Space";
      };
    };
  };
}
