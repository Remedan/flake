{ config, lib, pkgs, osConfig ? null, ... }:
let
  cfg = config.userModules.plasma;
  plasma-claude-usage = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "plasma-claude-usage";
    version = "2.4.0";
    src = pkgs.fetchFromGitHub {
      owner = "izll";
      repo = "plasma-claude-usage";
      tag = "v${version}";
      hash = "sha256-89saKplyDf8GD/owQ7frkWT7Zi/wo3s7ejVfkebIM8Q=";
    };
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      dest=$out/share/plasma/plasmoids/org.kde.plasma.claudeusage
      mkdir -p $dest
      cp -r metadata.json contents $dest/
      runHook postInstall
    '';
  };
in
{
  options.userModules.plasma = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = osConfig != null && osConfig.systemModules.base.desktopEnvironment == "KDE";
    };
  };
  config = lib.mkIf cfg.enable {
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
        "services/org.kde.dolphin.desktop"._launch = [ ]; # Conflict with Meta+E
      };
      hotkeys.commands = {
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
    ] ++ lib.optional config.userModules.claude.code.enable plasma-claude-usage;
  };
}
