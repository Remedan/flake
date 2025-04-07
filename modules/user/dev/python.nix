{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.dev.python;
in
{
  options.user-modules.dev.python = {
    enable = mkEnableOption "Python";
    extraVersions = mkOption {
      type = with types; listOf package;
      default = [];
    };
  };
  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        poetry
        python3
        ruff
        uv
      ] ++ map lib.lowPrio cfg.extraVersions;
    };
  };
}
