{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.dev.nodejs;
in
{
  options.user-modules.dev.nodejs = {
    enable = mkEnableOption "Node.js";
  };
  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        nodejs
      ];
      file.".npmrc".text = ''
        prefix = ''${HOME}/.npm-global
      '';
      sessionPath = [
        "$HOME/.npm-global/bin"
      ];
    };
  };
}
