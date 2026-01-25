{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.userModules.ranger;
in
{
  options.userModules.ranger = {
    enable = mkEnableOption "Ranger";
  };
  config = mkIf cfg.enable {
    programs.ranger = {
      enable = true;
      settings = mkIf config.userModules.kitty.enable {
        preview_images = true;
        preview_images_method = "kitty";
      };
    };
    # Prepend a line to the default rifle config
    xdg.configFile."ranger/rifle.conf".text =
      "mime ^image, has loupe, X, flag f = loupe -- \"$@\"\n"
      + (readFile "${pkgs.ranger}/share/doc/ranger/config/rifle.conf");
  };
}
