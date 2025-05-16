{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.packages;
in
{
  options.user-modules.packages = {
    enable = mkEnableOption "packages";
  };
  config = mkIf cfg.enable {
    home.shellAliases.lmstudio-wayland = "lmstudio --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto";
    nixpkgs.config.allowUnfreePredicate = pkg: elem (lib.getName pkg) [
      "1password"
      "jetbrains-toolbox"
      "lmstudio"
      "obsidian"
      "slack"
      "spotify"
      "steam"
      "steam-original"
      "steam-run"
      "steam-unwrapped"
      "terraform"
      "trezor-suite"
      "uhk-agent"
      "vscode"
      "winbox"
    ];
    home.packages = with pkgs; [
      # Core
      bat
      file
      gnupg
      htop
      killall
      nix-search-cli
      pciutils
      ripgrep
      rlwrap
      rsync
      tmux
      unzip

      # Networking
      dig
      ethtool
      iperf
      nmap
      tcpdump
      traceroute
      wireguard-tools

      # Extra
      btrfs-assistant
      dos2unix
      fastfetch
      fd
      fzf
      ghostscript
      gnome-solanum
      gparted
      imagemagick
      ispell
      lm_sensors
      magic-wormhole
      ncdu
      nix-tree
      ntfs3g
      progress
      pv
      pwgen
      trezor-suite
      trezorctl
      uhk-agent
      usbutils
      wl-clipboard
      yubikey-manager

      # Backup
      pika-backup

      # Audio
      playerctl
      spotify

      # Video
      ffmpeg
      mpv
      obs-studio
      vlc

      # Development
      bfg-repo-cleaner
      cmake
      direnv
      dive
      gcc
      gdb
      git-crypt
      jetbrains-toolbox
      jq
      nix-direnv
      postgresql
      tig

      # Infrastructure
      k9s
      krew
      kubectl
      remmina
      terraform
      winbox4
      wireshark

      # Internet
      chromium
      datovka
      deluge
      filezilla
      firefox
      thunderbird
      warp

      # Office
      libreoffice

      # AI
      lmstudio

      # Compatibility
      appimage-run
      bottles
      distrobox
      quickemu
      quickgui
      steam-run

      # Messaging
      element-desktop
      telegram-desktop
      vesktop # Discord

      # Graphics
      gimp3
      inkscape
      pinta

      # 3D
      blender
      freecad
      openscad
      prusa-slicer

      # Notes
      obsidian

      # Books
      calibre

      # Games
      aisleriot
      gargoyle
      gnome-mines
      gzdoom
      ifm
      prismlauncher # Minecraft
      scummvm
    ];
  };
}
