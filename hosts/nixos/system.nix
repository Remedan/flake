{ lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/virtualisation/qemu-vm.nix")
  ];

  virtualisation = {
    memorySize = 8192;
    cores = 4;
    diskSize = 16 * 1024;
    qemu.options = [ "-vga virtio" ];
  };

  zramSwap.enable = true;

  # The VM disk is ext4
  services.btrfs.autoScrub.enable = false;
  virtualisation.docker.storageDriver = "overlay2";
  systemModules.snapper.enable = false;

  users.users.remedan.initialPassword = "nixos";
  services.displayManager.autoLogin = {
    enable = true;
    user = "remedan";
  };

  systemModules = {
    base = {
      userName = "remedan";
      hostName = "nixos";
    };
  };
}
