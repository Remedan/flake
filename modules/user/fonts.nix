{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.fonts;
in
{
  options.user-modules.fonts = {
    enable = mkEnableOption "fonts";
  };
  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      dejavu_fonts
      eb-garamond
      fira
      fira-code
      inter
      iosevka-bin
      jetbrains-mono
      merriweather
      merriweather-sans
      montserrat
      nerd-fonts.symbols-only
      noto-fonts
      noto-fonts-emoji
      open-sans
      raleway
      roboto
      source-code-pro
      source-han-sans
      source-han-serif
      source-sans
      source-serif
    ];
  };
}
