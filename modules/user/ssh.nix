{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.ssh;
in
{
  options.user-modules.ssh = {
    enable = mkEnableOption "SSH";
  };
  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      # Default values will be removed in the future
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          extraOptions.IdentityAgent = "~/.1password/agent.sock";
          # Kitty sets TERM to 'xterm-kitty', we either need to either use the ssh kitten or change TERM on servers
          setEnv = mkIf (config.user-modules.kitty.enable) { TERM = "xterm-256color"; };
        };
      };
    };
  };
}
