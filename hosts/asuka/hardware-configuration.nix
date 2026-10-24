{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "virtio_pci"
    "usbhid"
    "usb_storage"
    "sr_mod"
  ];

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=10%"
        "mode=755"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/A504-9275";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/0935476a-49f6-4296-b05d-669320b72099";
      fsType = "btrfs";
      neededForBoot = true;
      options = [
        "subvol=@nix"
        "rw"
        "noatime"
        "compress-force=zstd:7"
        "ssd"
        "space_cache=v2"
        "autodefrag"
      ];
    };

    "/nix/persist" = {
      device = "/dev/disk/by-uuid/0935476a-49f6-4296-b05d-669320b72099";
      fsType = "btrfs";
      neededForBoot = true;
      options = [
        "subvol=@persist"
        "rw"
        "noatime"
        "compress-force=zstd:7"
        "ssd"
        "space_cache=v2"
        "autodefrag"
      ];
    };

    "/mnt/utm" = {
      device = "share";
      fsType = "9p";
      options = [
        "trans=virtio"
        "version=9p2000.L"
        "rw"
        "_netdev"
        "nofail"
        "msize=262144"
        "cache=mmap"
      ];
    };

    "${config.users.users.${config.custom.mainUser}.home}/Projects" = {
      device = "/mnt/utm";
      fsType = "fuse.bindfs";
      depends = [ "/mnt/utm" ];
      options = [
        "map=501/1000:@20/@100"
        "_netdev"
        "nofail"
      ];
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
