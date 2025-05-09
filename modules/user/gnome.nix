{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.gnome;
in
{
  options.user-modules.gnome = {
    enable = mkEnableOption "Gnome";
    extensions.enable = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = mkIf cfg.enable {
    programs.gnome-shell = mkIf cfg.extensions.enable {
      enable = true;
      extensions = with pkgs.gnomeExtensions; [
        {
          package = pkgs.gnome-shell-extensions;
          id = "drive-menu@gnome-shell-extensions.gcampax.github.com";
        }
        {
          package = pkgs.gnome-shell-extensions;
          id = "system-monitor@gnome-shell-extensions.gcampax.github.com";
        }
        { package = appindicator; }
        { package = bluetooth-battery-meter; }
        { package = caffeine; }
        { package = dash-to-dock; }
        { package = gsconnect; }
        { package = quick-settings-tweaker; }
        { package = search-light; }
        { package = smile-complementary-extension; }
        { package = solaar-extension; }
        { package = tiling-assistant; }
      ];
    };
    home.packages = with pkgs; [
      dconf-editor
      dconf2nix
      gnome-tweaks
      smile
    ];
    dconf.settings = {
      "org/gnome/desktop/input-sources" = with lib.gvariant; {
        per-window = true;
        sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "cz+qwerty" ]) (mkTuple [ "ibus" "anthy" ]) ];
        xkb-options = [ "caps:escape_shifted_capslock" ];
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/desktop/wm/preferences" = {
        focus-mode = "mouse";
        resize-with-right-button = true;
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = genList (n: "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${toString n}/") 5;
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Shift><Control>space";
        command = "1password --quick-access";
        name = "1Password Quick Access";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        binding = "<Super>Return";
        command = "kitty";
        name = "Terminal";
      };
      "org/gnome/settings-daemon/plugins/media-keysg/custom-keybindings/custom2" = {
        binding = "<Super>period";
        command = "smile";
        name = "Smile";
      };
      "org/gnome/settings-daemon/plugins/media-keysg/custom-keybindings/custom3" = {
        binding = "<Super>e";
        command = "emacsclient -c";
        name = "Emacs";
      };
      "org/gnome/settings-daemon/plugins/media-keysg/custom-keybindings/custom4" = {
        binding = "<Shift><Super>e";
        command = "emacsclient -ce '(full-calc)'";
        name = "Emacs Calc";
      };
      "org/gnome/mutter" = {
        dynamic-workspaces = true;
        edge-tiling = true;
        experimental-features = [ "scale-monitor-framebuffer" "xwayland-native-scaling" ];
      };
      "org/gnome/shell/extensions/dash-to-dock" = {
        apply-custom-theme = true;
        click-action = "minimize";
        dock-fixed = true;
        dock-position = "LEFT";
        extend-height = true;
        scroll-action = "cycle-windows";
      };
      "org/gnome/shell/extensions/search-light" = {
        background-color = lib.hm.gvariant.mkTuple [ 0.0 0.0 0.0 0.6 ];
        border-radius = 3.0;
        shortcut-search = [ "<Super>d" ];
      };
      "org/gnome/gnome-system-monitor" = {
        # Don't divide cpu usage by cpu count
        solaris-mode = false;
        show-whose-processes = "all";
      };
      "org/gnome/shell/extensions/quick-settings-tweaks" = {
        datemenu-hide-left-box = false;
        datemenu-hide-media-control = false;
        datemenu-hide-notifications = false;
        dnd-quick-toggle-enabled = false;
        media-enabled = false;
        notifications-enabled = false;
      };
    };
  };
}
