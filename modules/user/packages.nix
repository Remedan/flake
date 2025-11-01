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
      pandoc
      progress
      pv
      pwgen
      trezor-suite
      # trezorctl Has in insecure dependency, should be resolved in 0.20.0
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
      mediainfo
      mpv
      obs-studio
      vlc
      yt-dlp

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
      minikube
      nix-direnv
      pgcli
      tig
      websocat

      # Infrastructure
      ansible
      k9s
      krew
      kubectl
      kubernetes-helm
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
      samba
      thunderbird-latest
      warp

      # Office
      libreoffice

      # AI
      lmstudio

      # Compatibility
      appimage-run
      (bottles.override { removeWarningPopup = true; })
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
      bolt-launcher
      # gargoyle https://github.com/NixOS/nixpkgs/issues/445447
      gnome-mines
      gzdoom
      ifm
      prismlauncher # Minecraft
      scummvm
    ];
  };
}
