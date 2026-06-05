{ config, lib, pkgs, ... }:
let
  cfg = config.userModules.nextcloud;
in
{
  options.userModules.nextcloud = {
    enable = lib.mkEnableOption "Nextcloud";
  };
  config = lib.mkIf cfg.enable {
    services.nextcloud-client = {
      enable = true;
      startInBackground = true;
      package = config.lib.nixGL.wrap pkgs.nextcloud-client;
    };
  };
}
