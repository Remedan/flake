{ pkgs, lib, ... }:
{
  home = {
    username = "vojta";
    homeDirectory = "/home/vojta";
  };
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
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
  programs.fish.shellInit = ''
    source /home/vojta/.config/op/plugins.sh
  '';
  home.sessionPath = [ "$HOME/.cargo/bin" ];
  # For some reason, Nix programs can't find the CA bundle on Fedora 44
  home.sessionVariables.NIX_SSL_CERT_FILE = "/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem";
  userModules = {
    genericLinux.enable = true;
    plasma.enable = true;
    git.sshProgram = "/opt/1Password/op-ssh-sign";

    packages.enable = false;
    flatpak.enable = false;

    dev = {
      python.enable = true;
      nodejs.enable = true;
    };
  };
}
