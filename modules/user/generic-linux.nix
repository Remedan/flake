{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.userModules.genericLinux;
in
{
  options.userModules.genericLinux = {
    enable = mkEnableOption "Non-NixOS support";
  };

  config = mkIf cfg.enable {
    targets.genericLinux.enable = true;
    # We use nixGL because the default approach relies on creating a system systemd service
    # which doesn't work well on Fedora because of SELinux.
    targets.genericLinux.nixGL.packages = pkgs.nixgl;
  };
}
