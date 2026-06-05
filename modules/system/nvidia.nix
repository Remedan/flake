{ config, lib, ... }:
let
  inherit (lib) mkOption mkEnableOption types;
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

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      open = true;
      modesetting.enable = true;
      powerManagement.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.${cfg.driverVersion};
    };
  };
}
