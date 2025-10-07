{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.nextcloud;
in
{
  options.user-modules.nextcloud = {
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
