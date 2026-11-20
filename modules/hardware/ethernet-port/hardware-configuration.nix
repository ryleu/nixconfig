{
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];

    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ ];

      # systemd initrd is needed for tpm2 unlocking
      systemd.enable = true;

      luks.devices = {
        luksroot = {
          device = "/dev/disk/by-label/NIXLUKS";
          allowDiscards = true;
          bypassWorkqueues = true;
          crypttabExtraOpts = [
            "tpm2-device=auto"
            "tpm2-measure-pcr=yes" # tpm can only unlock 1 volume per boot
          ];
        };
      };
    };
  };

  fileSystems = {
    "/boot" = {
      label = "NIXBOOT";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    # generally i like to have compression to save a bit of space
    # noatime is not useful except in /home

    # TODO: replace with disko

    "/" = {
      device = "/dev/mapper/luksroot";
      fsType = "btrfs";
      options = [
        "subvol=@root"
        "compress=zstd"
        "noatime"
      ];
    };

    "/nix" = {
      device = "/dev/mapper/luksroot";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "compress=zstd"
        "noatime"
      ];
    };

    "/home" = {
      device = "/dev/mapper/luksroot";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "compress=zstd"
      ];
    };

    "/swap" = {
      device = "/dev/mapper/luksroot";
      fsType = "btrfs";
      options = [ "subvol=@swap" ];
    };
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 8 * 1024; # 8 gig swap
    }
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
}
