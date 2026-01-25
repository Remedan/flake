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
    # Enable graphics driver
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      open = true;

      # Select the driver version
      # https://wiki.nixos.org/wiki/Nvidia#Determining_the_correct_driver_version
      package = config.boot.kernelPackages.nvidiaPackages.${cfg.driverVersion};
    };
  };
}
