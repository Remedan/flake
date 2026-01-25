{ config, lib, ... }:
with lib;
let
  cfg = config.userModules.virt-manager;
in
{
  options.userModules.virt-manager = {
    enable = mkEnableOption "Virt Manager";
  };
  config = mkIf cfg.enable {
    dconf.settings = {
      "org/virt-manager/virt-manager/new-vm" = {
        firmware = "uefi";
      };
      "org/virt-manager/virt-manager/stats" = {
        enable-disk-poll = true;
        enable-memory-poll = true;
        enable-net-poll = true;
      };
      "org/virt-manager/virt-manager/vmlist-fields" = {
        disk-usage = true;
        memory-usage = true;
        network-traffic = true;
      };
      "org/virt-manager/virt-manager/virt-manager" = {
        xmleditor-enabled = true;
      };
    };
  };
}
