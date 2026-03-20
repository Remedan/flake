{ pkgs, lib, ... }:
{
  home = {
    username = "vojta";
    homeDirectory = "/home/vojta";
  };
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "claude-code"
  ];
  home.packages = with pkgs; [
    # Core
    bat
    htop
    neovim
    nix-search-cli
    ripgrep

    # Networking
    wireguard-tools

    # Extra
    fastfetch
    fd
    fzf
    magic-wormhole
    nix-tree
    pandoc
    pwgen

    # Development
    bfg-repo-cleaner
    direnv
    git-crypt
    glab
    just
    minikube
    nix-direnv
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
  programs.zsh.initContent = ''
    source /home/vojta/.config/op/plugins.sh
  '';
  programs.fish.shellInit = ''
    source /home/vojta/.config/op/plugins.sh
  '';
  home.sessionPath = [ "$HOME/.cargo/bin" ];
  # For some reasone, Nix programs can't find the CA bundle on Fedora 44
  home.sessionVariables.NIX_SSL_CERT_FILE = "/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem";
  programs.nix-index.enable = false;
  userModules = {
    genericLinux.enable = true;
    plasma.enable = true;
    git.sshProgram = "/opt/1Password/op-ssh-sign";

    packages.enable = false;
    flatpak.enable = false;

    dev = {
      python.enable = true;
      nodejs.enable = true;
      claude.code.enable = true;
      claude.desktop.enable = true;
    };
  };
}
