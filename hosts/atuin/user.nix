{
  config,
  pkgs,
  lib,
  ...
}:
{
  home = {
    username = "vojta";
    homeDirectory = "/home/vojta";
  };
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
      "vscode-extension-anthropic-claude-code"
    ];
  home.packages = with pkgs; [
    # Core
    bat
    htop
    ripgrep

    # Networking
    nmap
    wireguard-tools

    # Extra
    fastfetch
    fd
    fzf
    google-cloud-sdk
    gws
    magic-wormhole
    nix-tree
    pandoc
    pwgen
    qmk

    # Development
    bfg-repo-cleaner
    git-crypt
    glab
    just
    (lib.lowPrio minikube)
    mkcert
    pgcli
    tig
    websocat

    # Infrastructure
    awscli2
    kubernetes-helm
    k9s
    krew
    kubectl
  ];
  programs.fish.interactiveShellInit = ''
    if test -f ${config.xdg.configHome}/op/plugins.sh
      source ${config.xdg.configHome}/op/plugins.sh
    end
  '';
  programs.git.settings.gpg.ssh.program = "/opt/1Password/op-ssh-sign";
  home.sessionPath = [ "$HOME/.cargo/bin" ];
  # Overlay to remove nixpkgs' noto fonts, as the package breaks KDE title bars on Fedora
  nixpkgs.overlays = [ (final: prev: { noto-fonts = prev.emptyDirectory; }) ];
  userModules = {
    genericLinux.enable = true;
    ssh.agentSocket = "${config.home.homeDirectory}/.1password/agent.sock";

    packages.enable = false;
    flatpak.enable = false;

    dev = {
      python.enable = true;
      nodejs.enable = true;
    };
  };
}
