{ pkgs, lib, ... }:
let
  inherit (lib) mkForce;
in
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
  programs.git.settings.gpg.ssh.program = "/opt/1Password/op-ssh-sign";
  programs.ssh.settings."*".IdentityAgent = mkForce "~/.1password/agent.sock";
  home.sessionPath = [ "$HOME/.cargo/bin" ];
  # Overlay to remove nixpkgs' noto fonts, as the package breaks KDE title bars on Fedora
  nixpkgs.overlays = [ (final: prev: { noto-fonts = prev.emptyDirectory; }) ];
  userModules = {
    genericLinux.enable = true;
    plasma.enable = true;

    packages.enable = false;
    flatpak.enable = false;

    dev = {
      python.enable = true;
      nodejs.enable = true;
    };
  };
}
