{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.system-modules.boot;
in
{
  options.system-modules.boot = {
    loader = mkOption {
      type = types.enum [ "systemd-boot" "grub" ];
      default = "systemd-boot";
    };
    luks = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      uuid = mkOption {
        type = types.str;
      };
    };
  };

  config = {
    boot = mkMerge [
      {
        loader.efi.canTouchEfiVariables = true;
        plymouth.enable = true;
      }
      (mkIf (cfg.loader == "systemd-boot") {
        loader.systemd-boot.enable = true;
      })
      (mkIf (cfg.loader == "grub") {
        loader.grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          enableCryptodisk = cfg.luks.enable;
        };
        loader.efi.efiSysMountPoint = "/boot/efi";
      })
      (mkIf cfg.luks.enable {
        initrd.luks.devices.root = {
          device = "/dev/disk/by-uuid/${cfg.luks.uuid}";
          allowDiscards = true;
        };
      })
    ];
  };
}
