{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.userModules.kitty;
in
{
  options.userModules.kitty = {
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
        name = "IosevkaTerm Nerd Font";
        size = 11;
      };
      themeFile = cfg.colorscheme;
      settings = {
        window_padding_width = 5;
        tab_bar_edge = "top";
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        enable_audio_bell = false;
        enabled_layouts = "tall,horizontal,grid";
      };
      quickAccessTerminalConfig = {
        app_id = "dock";
      };
    };
    home.shellAliases = {
      s = "kitten ssh";
    };
  };
}
