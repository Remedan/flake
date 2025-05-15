{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.git;
in
{
  options.user-modules.git = {
    enable = mkEnableOption "Git";
    userName = mkOption {
      type = types.str;
      default = "Vojtěch Balák";
    };
    userEmail = mkOption {
      type = types.str;
      default = "vojtech@balak.me";
    };
    signingKey = mkOption {
      type = types.str;
      default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCrvW1wIRC7BJ6Hp7NUlO4q4VUQPze2Gn+XstOOgL81PC/Rkkp2awx33suCkLvxdNL5YyXiw8N0JmFA4DsjWhFXnQuNAtMB01CICUVwexTxw8ZtmEOOcY5xwNaK/xfbl5+QCNgq0bEl3SBYmfnh2sNXHHMQNchPIjYZtLLzZ7QTDZrjOTmeqr0otmH6JK8oo/f/8G2/9NkY75GDcjwaPv6R4aH7nlO4hehLp58bYo3A/u7hcrvXz77h8On9mDyLu1u/LkH7rqBxjYfvNAqInCxT7BWb4YDci0Ho8c5NkRuHADzmkR6uViwCmJHWccu9yX5JddC9ySmsATuRlNBab9VD";
    };
    sshProgram = mkOption {
      type = types.str;
      default = "${pkgs._1password-gui}/bin/op-ssh-sign";
    };
  };
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;

      userName = cfg.userName;
      userEmail = cfg.userEmail;

      signing.signByDefault = true;
      signing.key = cfg.signingKey;

      lfs.enable = true;

      # A lot of things taken from here
      # https://blog.gitbutler.com/how-git-core-devs-configure-git
      extraConfig = {
        help.autocorrect = "prompt";
        init.defaultBranch = "main";
        column.ui = "auto";
        branch.sort = "-committerdate";
        tag.sort = "version:refname";
        diff = {
          algorithm = "histogram";
          colorMoved = "plain";
          mnemonicPrefix = true;
          renames = true;
        };
        fetch = {
          prune = true;
          pruneTags = true;
          all = true;
        };
        pull = {
          rebase = true;
        };
        push = {
          autoSetupRemote = true;
          followTags = true;
        };
        merge = {
          conflictstyle = "zdiff3";
        };
        rebase = {
          autoSquash = true;
          autoStash = true;
          updateRefs = true;
        };
        rerere = {
          enabled = true;
          autocomplete = true;
        };
        gpg = {
          format = "ssh";
          ssh.program = cfg.sshProgram;
          ssh.allowedSignersFile = "~/.config/git/allowed_signers";
        };
      };
    };
    xdg.configFile."git/allowed_signers".text = cfg.userEmail + " " + cfg.signingKey;
  };
}
