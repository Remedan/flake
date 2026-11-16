{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption mkEnableOption types;
  cfg = config.systemModules.nvidia;
in
{
  options.systemModules.nvidia = {
    enable = mkEnableOption "Nvidia";
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      open = true;
      powerManagement.enable = true;
    };
    # Enable cuda for packages that benefit from it
    services.ollama.package = pkgs.ollama-cuda;
    # nixpkgs.overlays = [
    #   (final: prev: { blender = prev.blender.override { cudaSupport = true; }; })
    # ];
  };
}
