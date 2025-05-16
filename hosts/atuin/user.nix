{ pkgs, ... }:
{
  home = {
    username = "vojta";
    homeDirectory = "/home/vojta";
  };
  home.packages = with pkgs; [
    awscli2
    bat
    bfg-repo-cleaner
    direnv
    fastfetch
    fd
    fzf
    git-crypt
    htop
    just
    k9s
    krew
    kubectl
    neovim
    nix-direnv
    nix-search-cli
    nix-tree
    postgresql
    pwgen
    ripgrep
    tig
    ventoy
    wireguard-tools
  ];
  programs.zsh.initContent = ''
    source /home/vojta/.config/op/plugins.sh
  '';
  home.sessionPath = [ "$HOME/.cargo/bin" ];
  user-modules = {
    nixgl.enable = true;
    git.sshProgram = "/opt/1Password/op-ssh-sign";
    music.enableMpris = false;
    gnome.extensions.enable = false;

    packages.enable = false;
    flatpak.enable = false;
  };
}
