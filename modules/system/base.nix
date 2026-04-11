{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.systemModules.base;
in
{
  options.systemModules.base = {
    userName = mkOption {
      type = types.str;
    };
    hostName = mkOption {
      type = types.str;
    };
    cpuType = mkOption {
      type = with types; nullOr (enum [ "amd" "intel" ]);
      default = null;
    };
    desktopEnvironment = mkOption {
      type = types.enum [ "Gnome" "KDE" "Hyprland" ];
      default = "KDE";
    };
  };

  config = mkMerge [
    {
      # In theory, this should never be updated.
      # However, I do update it when a new NixOS version releases,
      # after scanning the release notes for breaking changes.
      # https://nixos.org/manual/nixos/stable/release-notes
      system.stateVersion = "25.11";

      # Install common non-free firmware
      hardware.enableRedistributableFirmware = true;

      # Update CPU microcode
      hardware.cpu = {
        amd.updateMicrocode = cfg.cpuType == "amd";
        intel.updateMicrocode = cfg.cpuType == "intel";
      };

      # Firmware upgrades
      services.fwupd.enable = true;

      # Regularly scrub btrfs filesystems
      services.btrfs.autoScrub.enable = true;

      # Networking
      networking = {
        hostName = cfg.hostName;
        networkmanager.enable = true;
      };

      # Allow KDEConnect
      networking.firewall = rec {
        allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
        allowedUDPPortRanges = allowedTCPPortRanges;
      };

      time.timeZone = "Europe/Prague";

      i18n =
        let
          # Set language to English but formats to Czech
          locale = "en_US.UTF-8";
          format = "cs_CZ.UTF-8";
        in
        {
          defaultLocale = locale;
          extraLocaleSettings = {
            LC_ADDRESS = format;
            LC_IDENTIFICATION = format;
            LC_MEASUREMENT = format;
            LC_MONETARY = format;
            LC_NAME = format;
            LC_NUMERIC = format;
            LC_PAPER = format;
            LC_TELEPHONE = format;
            LC_TIME = format;
          };
        };

      # Printing
      services.printing = {
        enable = true;
        drivers = with pkgs; [
          gutenprint
          gutenprintBin
          canon-cups-ufr2
          cnijfilter2
        ];
      };

      # Network Printer Discovery
      services.avahi = {
        enable = true;
        nssmdns4 = true;
      };

      # Scanning
      hardware.sane.enable = true;

      # Enable sound with pipewire
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
      security.rtkit.enable = true;

      # Enable bluetooth
      hardware.bluetooth.enable = true;

      # SSH Server
      services.openssh = {
        enable = lib.mkDefault true;
        settings.PasswordAuthentication = lib.mkDefault false;
      };

      # User setup
      users.groups.${cfg.userName} = {
        gid = 1000;
      };
      users.users.${cfg.userName} = {
        uid = 1000;
        group = cfg.userName;
        isNormalUser = true;
        description = "Vojtěch Balák";
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
          "libvirtd"
          "scanner"
          "lp"
          "video"
          "adbusers"
        ];
        shell = pkgs.fish;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQOh94Y3qiel5HPE9I7/mKotaFTLpeC4CD2sSZ9qr0d"
        ];
      };

      nix = {
        settings = {
          trusted-users = [ "root" cfg.userName ];
          substituters = [
            "https://nix-community.cachix.org"
          ];
          trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
        };
        optimise.automatic = true;
        gc = {
          automatic = true;
          options = "--delete-older-than 30d";
        };
      };

      # Packages and Applications
      environment.systemPackages = with pkgs; [
        cifs-utils
        git
        neovim
        wget
      ];

      programs.zsh.enable = true;
      programs.fish.enable = true;

      programs._1password.enable = true;
      programs._1password-gui.enable = true;
      programs._1password-gui.polkitPolicyOwners = [ cfg.userName ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        # System packages
        "1password"
        "1password-cli"
        "canon-cups-ufr2"
        "cnijfilter2"
        "cuda_cccl"
        "cuda_cudart"
        "cuda_nvcc"
        "libcublas"
        "nvidia-settings"
        "nvidia-x11"
        "steam"
        "steam-original"
        "steam-run"
        "steam-unwrapped"
        "uhk-agent"
        "uhk-udev-rules"
        # Home Manager packages (useGlobalPkgs = true)
        "claude-code"
        "jetbrains-toolbox"
        "spotify"
        "terraform"
        "trezor-suite"
        "vscode"
        "vscode-extension-anthropic-claude-code"
        "winbox"
      ];

      # Flatpak
      services.flatpak.enable = true;

      # Enable Logitech devices support and Solaar
      hardware.logitech.wireless.enable = true;
      hardware.logitech.wireless.enableGraphical = true;

      # Udev
      services.udev.packages = with pkgs; [
        yubikey-personalization
        uhk-udev-rules
      ];

      # Smart Card / Yubikey support
      services.pcscd.enable = true;

      # Virtualisation
      virtualisation.docker = {
        enable = true;
        storageDriver = "btrfs";
        autoPrune = {
          enable = true;
          flags = [ "--all" "--volumes" ];
        };
      };
      virtualisation.libvirtd = {
        enable = true;
        qemu.swtpm.enable = true;
      };
      programs.virt-manager.enable = true;
      virtualisation.spiceUSBRedirection.enable = true;

      # Polkit
      security.polkit.enable = true;

      # Gaming
      programs.steam = {
        enable = true;
        # This fixes Steam having a weird cursor
        extraPackages = with pkgs; [ adwaita-icon-theme kdePackages.breeze ];
      };
      programs.gamemode.enable = true;

      # Local LLMs
      services.ollama.enable = true;

      # Trezor
      services.trezord.enable = true;

      # Home Manager
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-backup";
      };

      # Custom Modules
      systemModules.nix-ld.enable = mkDefault true;
      systemModules.snapper.enable = mkDefault true;
    }
    (mkIf (cfg.desktopEnvironment == "Gnome") {
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;

      # Add the option to open a directory in Kitty to Nautilus
      programs.nautilus-open-any-terminal = {
        enable = true;
        terminal = "kitty";
      };

      i18n.inputMethod = {
        enable = true;
        type = "ibus";
        # Enable Japanese input
        ibus.engines = with pkgs.ibus-engines; [ anthy mozc ];
      };
    })
    (mkIf (cfg.desktopEnvironment == "KDE") {
      services.displayManager.plasma-login-manager.enable = true;
      services.desktopManager.plasma6.enable = true;
      programs.kdeconnect.enable = true;

      environment.systemPackages = with pkgs; [
        kdePackages.plasma-keyboard
      ];
    })
    (mkIf (cfg.desktopEnvironment == "Hyprland") {
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
      programs.hyprland = {
        enable = true;
        withUWSM = true;
      };
    })
  ];
}
