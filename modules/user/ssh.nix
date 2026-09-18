{ config, lib, pkgs, ... }:
let
  cfg = config.userModules.ssh;
in
{
  options.userModules.ssh = {
    enable = lib.mkEnableOption "SSH";
  };
  config = lib.mkIf cfg.enable {
    # We have to pin specific keys for specific hosts to avoid too many authentication failures
    home.file.".ssh/codeberg.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICkkw0jYCkX2qhnLZxLPa4vEs97gRFM+F8zXKNdOY7Xn Codeberg\n";
    home.file.".ssh/twoflower.pub".text = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCrvW1wIRC7BJ6Hp7NUlO4q4VUQPze2Gn+XstOOgL81PC/Rkkp2awx33suCkLvxdNL5YyXiw8N0JmFA4DsjWhFXnQuNAtMB01CICUVwexTxw8ZtmEOOcY5xwNaK/xfbl5+QCNgq0bEl3SBYmfnh2sNXHHMQNchPIjYZtLLzZ7QTDZrjOTmeqr0otmH6JK8oo/f/8G2/9NkY75GDcjwaPv6R4aH7nlO4hehLp58bYo3A/u7hcrvXz77h8On9mDyLu1u/LkH7rqBxjYfvNAqInCxT7BWb4YDci0Ho8c5NkRuHADzmkR6uViwCmJHWccu9yX5JddC9ySmsATuRlNBab9VD Personal\n";
    home.file.".ssh/twoflower-borg.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAXXOzpXjC3xucybQo9nmQAkjOZuEJSqxVo1RdDst1zz Twoflower Borg Weatherwax\n";
    programs.ssh = {
      enable = true;
      # Default values will be removed in the future
      enableDefaultConfig = false;
      settings = {
        "codeberg.org" = {
          IdentityFile = "~/.ssh/codeberg.pub";
          IdentitiesOnly = true;
        };
        "twoflower.octo.cafe" = {
          IdentityFile = "~/.ssh/twoflower.pub";
          IdentitiesOnly = true;
        };
        "twoflower-borg" = {
          HostName = "twoflower.octo.cafe";
          User = "borg";
          Port = 2222;
          IdentityFile = "~/.ssh/twoflower-borg.pub";
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
