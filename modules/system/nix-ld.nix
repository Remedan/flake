{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.systemModules.nix-ld;
in
{
  options.systemModules.nix-ld = {
    enable = mkEnableOption "nix-ld";
  };

  config = mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
      libraries = pkgs.appimageTools.defaultFhsEnvArgs.targetPkgs pkgs;
    };
  };
}
