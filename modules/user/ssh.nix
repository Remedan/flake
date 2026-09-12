{ config, lib, pkgs, ... }:
let
  cfg = config.userModules.ssh;
in
{
  options.userModules.ssh = {
    enable = lib.mkEnableOption "SSH";
  };
  config = lib.mkIf cfg.enable {
    home.file.".ssh/codeberg.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICkkw0jYCkX2qhnLZxLPa4vEs97gRFM+F8zXKNdOY7Xn Codeberg\n";
    programs.ssh = {
      enable = true;
      # Default values will be removed in the future
      enableDefaultConfig = false;
      settings = {
        # Pin a specific key for Codeberg, otherwise we get too many auth failures after trying all the keys in Bitwarden.
        "codeberg.org" = {
          IdentityFile = "~/.ssh/codeberg.pub";
          IdentitiesOnly = true;
        };
        "*" = {
          IdentityAgent = "~/.bitwarden-ssh-agent.sock";
          # Kitty sets TERM to 'xterm-kitty', we either need to either use the ssh kitten or change TERM on servers
          SetEnv = lib.mkIf (config.userModules.kitty.enable) { TERM = "xterm-256color"; };
        };
      };
    };
    home.sessionVariables.SSH_AUTH_SOCK = "$HOME/.bitwarden-ssh-agent.sock";
    # Make the envvar available to daemons such as Emacs
    systemd.user.sessionVariables.SSH_AUTH_SOCK = "$HOME/.bitwarden-ssh-agent.sock";
  };
}
