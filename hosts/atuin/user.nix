{ pkgs, ... }:
{
  home = {
    username = "vojta";
    homeDirectory = "/home/vojta";
  };
  home.packages = with pkgs; [
    awscli2
    bat
    direnv
    fastfetch
    fd
    fzf
    git-crypt
    htop
    just
    k9s
    neovim
    nix-search
    nix-tree
    ripgrep
    tig
    wireguard-tools
  ];
  programs.zsh.initContent = ''
    source /home/vojta/.config/op/plugins.sh
  '';
  user-modules = {
    nixgl.enable = true;
    git.sshProgram = "/opt/1Password/op-ssh-sign";

    # Disable modules that I haven't tested on Fedora
    packages.enable = false;
    fonts.enable = false;
    gnome.enable = false;
    gpg.enable = false;
    flatpak.enable = false;
  };
}
