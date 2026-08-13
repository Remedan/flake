{ config, lib, pkgs, ... }:
let
  cfg = config.userModules.packages;
in
{
  options.userModules.packages = {
    enable = lib.mkEnableOption "packages";
  };
  config = lib.mkIf cfg.enable {
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
      vorta

      # Audio
      picard
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
      dive
      gcc
      gdb
      git-crypt
      jq
      (lib.lowPrio minikube) # Conflict with kubectl
      mkcert
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
      winbox
      wireshark

      # Internet
      chromium
      datovka
      deluge
      filezilla
      samba
      thunderbird

      # Office
      libreoffice

      # Compatibility
      (bottles.override { removeWarningPopup = true; })
      distrobox
      quickemu
      quickgui
      steam-run
      winboat
      xlsclients

      # Messaging
      element-desktop
      telegram-desktop
      vesktop

      # Graphics
      gimp
      inkscape
      krita

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
      trezorctl
      uhk-agent
      yubikey-manager

      # Games
      bolt-launcher
      gargoyle
      uzdoom
      ifm
      prismlauncher
      scummvm
    ];
  };
}
