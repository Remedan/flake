{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.userModules.fonts;
in
{
  options.userModules.fonts = {
    enable = mkEnableOption "fonts";
  };
  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      # General
      dejavu_fonts
      eb-garamond
      inter
      merriweather
      merriweather-sans
      montserrat
      noto-fonts
      noto-fonts-color-emoji
      open-sans
      raleway
      roboto
      source-han-sans
      source-han-serif
      source-sans
      source-serif

      # Programming/Terminal
      fira
      fira-code
      iosevka-bin
      jetbrains-mono
      nerd-fonts.symbols-only
      source-code-pro
    ];
  };
}
