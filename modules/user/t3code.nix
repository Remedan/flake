{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption;
  cfg = config.userModules.t3code;
in
{
  options.userModules.t3code = {
    enable = mkEnableOption "T3 Code";
  };

  config = lib.mkIf cfg.enable {
    programs.t3code = {
      enable = true;
      package = pkgs.t3code.override {
        # Get those from the environment
        enableCodex = false;
        enableGitHub = false;
      };
      server.enable = true;
    };
  };
}
