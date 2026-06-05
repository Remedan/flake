{ config, lib, pkgs, ... }:
let
  cfg = config.userModules.genericLinux;
in
{
  options.userModules.genericLinux = {
    enable = lib.mkEnableOption "Non-NixOS support";
  };

  config = lib.mkIf cfg.enable {
    targets.genericLinux.enable = true;
    # We use nixGL because the default approach relies on creating a system systemd service
    # which doesn't work well on Fedora because of SELinux.
    targets.genericLinux.nixGL.packages = pkgs.nixgl;
  };
}
