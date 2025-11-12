{ pkgs, ... }:
{
  home = {
    username = "vojta";
    homeDirectory = "/home/vojta";
  };
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

    # Internet
    thunderbird-latest # Fedora only ships the ESR channel
  ];
  programs.zsh.initContent = ''
    source /home/vojta/.config/op/plugins.sh
  '';
  home.sessionPath = [ "$HOME/.cargo/bin" ];
  user-modules = {
    genericLinux.enable = true;
    git.sshProgram = "/opt/1Password/op-ssh-sign";
    music.enableMpris = false;
    gnome.extensions.enable = false;

    packages.enable = false;
    flatpak.enable = false;
  };
}
