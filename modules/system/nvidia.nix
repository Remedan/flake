{ config, lib, ... }:
with lib;
let
  cfg = config.systemModules.nvidia;
in
{
  options.systemModules.nvidia = {
    enable = mkEnableOption "Nvidia";
    driverVersion = mkOption {
      type = types.enum [ "stable" "beta" ];
      default = "stable";
    };
  };

  config = mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.${cfg.driverVersion};
    };
  };
}
