{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.userModules.vscode;
in
{
  options.userModules.vscode = {
    enable = mkEnableOption "VSCodium";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
    };
  };
}
