{ pkgs, ... }:
{
  home = {
    username = "vojta";
    homeDirectory = "/home/vojta";
  };
  home.packages = with pkgs; [
    awscli2
    just
    k9s
    nix-search
    nix-tree
  ];
  programs.zsh.initContent = ''
    source /home/vojta/.config/op/plugins.sh
  '';
  user-modules = {
    nixgl.enable = true;
    git.sshProgram = "/opt/1Password/op-ssh-sign";

    # Disable modules that I haven't tested on Fedora
    packages.enable = false;
    music.enable = false;
    fonts.enable = false;
    gtk.enable = false;
    gnome.enable = false;
    virt-manager.enable = false;
    gpg.enable = false;
    flatpak.enable = false;
  };
}
