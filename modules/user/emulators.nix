{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.emulators;
in
{
  options.user-modules.emulators = {
    enable = mkEnableOption "Emulators";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (retroarch.withCores (cores: with cores; [
        citra
      ]))
    ];
  };
}
