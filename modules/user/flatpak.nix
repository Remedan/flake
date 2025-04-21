{ config, lib, ... }:
with lib;
let
  cfg = config.user-modules.flatpak;
in
{
  options.user-modules.flatpak = {
    enable = mkEnableOption "Flatpak";
  };
  config = mkIf cfg.enable {
    services.flatpak = {
      enable = true;
      remotes = lib.mkOptionDefault [
        {
          name = "flathub-beta";
          location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
        }
      ];
      packages = [
      ];
    };
  };
}
