{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.userModules.vscodium;
in
{
  options.userModules.vscodium = {
    enable = mkEnableOption "VSCodium";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
    };
  };
}
