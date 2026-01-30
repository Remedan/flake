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
      input.keyboard = {
        layouts = [
          { layout = "us"; }
          { layout = "cz"; variant = "qwerty"; }
        ];
        options = [ "caps:escape_shifted_capslock" ];
      };
      shortcuts = {
        "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "Meta+Space";
        "services/emacsclient.desktop"._launch = "Meta+E";
        "services/kitty.desktop"._launch = "Meta+Return";
        "services/net.local.1password.desktop"._launch = "Ctrl+Shift+Space";
        "services/org.kde.dolphin.desktop"._launch = [ ]; # Conflict with Meta+E
      };
      workspace = {
        wallpaperPictureOfTheDay.provider = "bing";
        wallpaperFillMode = "preserveAspectCrop";
      };
      kscreenlocker.appearance.wallpaperPictureOfTheDay.provider = "bing";
      krunner.position = "center";
      configFile = {
        kdeglobals = {
          General.TerminalApplication = "kitty";
          General.TerminalService = "kitty.desktop";
        };
        kscreenlockerrc."Greeter/Wallpaper/org.kde.potd/General".FillMode = 2;
        kwinrc = {
          Windows.DelayFocusInterval = 100;
          Windows.FocusPolicy = "FocusFollowsMouse";
        };
      };
    };
  };
}
