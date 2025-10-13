{ config, lib, ... }:
with lib;
let
  cfg = config.user-modules.shell;
in
{
  options.user-modules.shell = {
    enable = mkEnableOption "shell";
  };
  config = mkIf cfg.enable {
    home = {
      sessionPath = [
        "$HOME/.local/bin"
        "$HOME/.krew/bin"
      ];
      sessionVariables = {
        EDITOR = if config.user-modules.emacs.service then "emacsclient -nw" else "emacs -nw";
        # Enable wayland for chromium-based apps
        NIXOS_OZONE_WL = 1;
      };
      shellAliases = {
        e = "eval \"$EDITOR\"";
        E = "sudoedit";
        ip = "ip -c";
        sxiv = "sxiv -a";
      };
    };
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "direnv"
          "docker"
          "docker-compose"
          "fzf"
          "git"
          "kubectl"
          "poetry"
          "poetry-env"
          "shrink-path"
        ];
      };
    };
    programs.starship = {
      enable = true;
      settings = {
        directory.truncate_to_repo = false;
        kubernetes.disabled = false;
      };
    };
    programs.kubecolor = {
      enable = true;
      enableAlias = true;
    };
  };
}
