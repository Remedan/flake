{ config, lib, pkgs, ... }:
let
  cfg = config.userModules.genericLinux;
in
{
  options.userModules.genericLinux = {
    enable = lib.mkEnableOption "Non-NixOS support";
  };

  config = lib.mkIf cfg.enable {
    # GPU drivers are provided via targets.genericLinux.gpu (enabled by default).
    # After switching, run `sudo non-nixos-gpu-setup` whenever home-manager warns about it.
    targets.genericLinux.enable = true;
  };
}
