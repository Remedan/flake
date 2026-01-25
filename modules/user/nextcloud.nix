{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.userModules.nextcloud;
in
{
  options.userModules.nextcloud = {
    enable = mkEnableOption "Nextcloud";
  };
  config = mkIf cfg.enable {
    services.nextcloud-client = {
      enable = true;
      startInBackground = true;
      package = config.lib.nixGL.wrap pkgs.nextcloud-client;
    };
  };
}
