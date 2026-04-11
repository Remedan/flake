{ config, lib, ... }:
with lib;
let
  cfg = config.systemModules.snapper;
in
{
  options.systemModules.snapper = {
    enable = mkEnableOption "Snapper";
  };

  config = mkIf cfg.enable {
    services.snapper.configs.home = {
      SUBVOLUME = "/home";
      ALLOW_USERS = [ config.systemModules.base.userName ];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
    };
    systemd.tmpfiles.rules = [
      "v /home/.snapshots 0770 root root"
    ];
  };
}
