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
        "com.github.PintaProject.Pinta" # TODO switch to Nixpkgs when Pinta is updated to 3
        "org.gimp.GIMP" # TODO switch to Nixpkgs when GIMP is updated to 3
      ];
    };
  };
}
