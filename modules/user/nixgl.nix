{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.nixgl;
in
{
  options.user-modules.nixgl = {
    enable = mkEnableOption "nixGL";
  };

  config = mkIf cfg.enable {
    nixGL.packages = pkgs.nixgl;
  };
}
