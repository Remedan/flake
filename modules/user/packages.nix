{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.userModules.packages;
in
{
  options.userModules.packages = {
    enable = mkEnableOption "packages";
  };
  config = mkIf cfg.enable {
    home.shellAliases.lmstudio-wayland = "lmstudio --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto";
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
      usbutils
      wl-clipboard

      # Backup
      pika-backup
      vorta

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
      hcloud
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
      winboat

      # Messaging
      element-desktop
      telegram-desktop
      vesktop

      # Graphics
      gimp3
      inkscape
      pinta

      # 3D
      blender
      freecad
      openscad
      prusa-slicer

      # Books
      calibre

      # Hardware
      android-tools
      rpi-imager
      trezor-suite
      # trezorctl Has an insecure dependency, should be resolved in 0.20.0
      uhk-agent
      yubikey-manager

      # Games
      aisleriot
      bolt-launcher
      gargoyle
      gnome-mines
      gzdoom
      # ifm Broken package
      prismlauncher # Minecraft
      scummvm
    ];
  };
}
