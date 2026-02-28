{ config, lib, ... }:
with lib;
let
  cfg = config.userModules.shell;
in
{
  options.userModules.shell = {
    enable = mkEnableOption "shell";
  };
  config = mkIf cfg.enable {
    home = {
      shell.enableZshIntegration = true;
      shell.enableFishIntegration = true;
      sessionPath = [
        "$HOME/.local/bin"
        "$HOME/.krew/bin"
      ];
      sessionVariables = {
        EDITOR = if config.userModules.emacs.service then "emacsclient -nw" else "emacs -nw";
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
      dotDir = "${config.xdg.configHome}/zsh";
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
    programs.fish = {
      enable = true;
      shellInit = ''
        set fish_greeting
      '';
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
    programs.atuin = {
      enable = true;
      daemon.enable = true;
      flags = [ "--disable-up-arrow" ];
    };
  };
}
