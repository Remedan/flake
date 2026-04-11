{ config, lib, pkgs, osConfig ? null, ... }:
with lib;
let
  cfg = config.userModules.plasma;
in
{
  options.userModules.plasma = {
    enable = mkOption {
      type = types.bool;
      default = osConfig != null && osConfig.systemModules.base.desktopEnvironment == "KDE";
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
      hotkeys.commands = {
        "1password-quick-access" = {
          name = "1Password Quick Access";
          key = "Ctrl+Shift+Space";
          command = "1password --quick-access";
        };
        "kitty-quick-access" = {
          name = "Kitty Quick Access";
          key = "Meta+Shift+Return";
          command = "kitten quick-access-terminal";
        };
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
    home.packages = with pkgs; [
      rc2nix
      kdePackages.kcalc
      kdePackages.kmines
      kdePackages.kpat
    ];
  };
}
