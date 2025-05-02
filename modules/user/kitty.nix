{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.kitty;
in
{
  options.user-modules.kitty = {
    enable = mkEnableOption "Kitty";
    colorscheme = mkOption {
      type = types.str;
      default = "Argonaut";
    };
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      package = config.lib.nixGL.wrap pkgs.kitty;
      font = {
        name = "Iosevka Term";
        size = 11;
      };
      themeFile =
        let
          themeNames = {
            selenized-dark = "Solarized Dark";
            gruvbox-dark = "Gruvbox Dark";
          };
        in
          themeNames.${cfg.colorscheme} or cfg.colorscheme;
      settings = {
        window_padding_width = 5;
        tab_bar_edge = "top";
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        enable_audio_bell = false;
      };
    };
    home.shellAliases = {
      s = "kitten ssh";
    };
  };
}
