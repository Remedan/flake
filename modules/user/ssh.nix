{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.userModules.ssh;
in
{
  options.userModules.ssh = {
    enable = mkEnableOption "SSH";
  };
  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      # Default values will be removed in the future
      enableDefaultConfig = false;
      settings = {
        "*" = {
          IdentityAgent = "~/.1password/agent.sock";
          # Kitty sets TERM to 'xterm-kitty', we either need to either use the ssh kitten or change TERM on servers
          SetEnv = mkIf (config.userModules.kitty.enable) { TERM = "xterm-256color"; };
        };
      };
    };
  };
}
