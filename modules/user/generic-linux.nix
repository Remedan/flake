{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.genericLinux;
in
{
  options.user-modules.genericLinux = {
    enable = mkEnableOption "Non-NixOS support";
  };

  config = mkIf cfg.enable {
    targets.genericLinux.enable = true;
    # We use nixGL becuase the default approach relies on creating a system systemd service
    # which doesn't work well on Fedora because of SELinux.
    targets.genericLinux.nixGL.packages = pkgs.nixgl;
  };
}
