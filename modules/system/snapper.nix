{ config, lib, ... }:
let
  cfg = config.systemModules.snapper;
in
{
  options.systemModules.snapper = {
    enable = lib.mkEnableOption "Snapper";
  };

  config = lib.mkIf cfg.enable {
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
