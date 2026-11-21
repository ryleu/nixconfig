# unified boot drive layout
{ inputs, ... }:
{
  settings.disk =
    { lib, ... }:
    {
      options = {
        encrypted = lib.mkOption {
          type = lib.types.bool;
          description = "Whether the drive is encrypted with LUKS";
        };
        bootSize = lib.mkOption {
          type = lib.types.str;
          default = "2G";
          description = "Size of the boot partition.";
        };
        swapSize = lib.mkOption {
          type = lib.types.str;
          default = "8G";
          description = "Size of the swapfile.";
        };
      };
    };

  flake.modules.nixos.disk =
    { config, lib, ... }:
    let
      disk = config.parts.disk;

      btrfs = {
        type = "btrfs";
        extraArgs = [
          "-f"
          "-L"
          "NIXROOT"
        ];
        # split root across multiple subvolumes for different settings and partial backups
        subvolumes = {
          "@root" = {
            mountpoint = "/";
            mountOptions = [
              "compress=zstd"
              "noatime"
            ];
          };
          "@nix" = {
            mountpoint = "/nix";
            mountOptions = [
              "compress=zstd"
              "noatime"
            ];
          };
          "@home" = {
            mountpoint = "/home";
            # noatime is useful in /home
            mountOptions = [ "compress=zstd" ];
          };
          # disko handles setting swap up
          "@swap" = {
            mountpoint = "/swap";
            swap.swapfile.size = disk.swapSize;
          };
        };
      };

      # if using LUKS
      luks = {
        type = "luks";
        name = "luksroot";
        # disko will ask for password on format
        settings = {
          allowDiscards = true;
          bypassWorkqueues = true;
          # enable TPM unlock
          # can configure PIN option with `systemd-cryptenroll --tpm2-with-pin=yes`
          crypttabExtraOpts = [
            "tpm2-device=auto"
            "tpm2-measure-pcr=yes" # one volume per boot
          ];
        };
        # BTRFS layout inside of LUKS part
        content = btrfs;
      };
    in
    {
      imports = [ inputs.disko.nixosModules.disko ];
      config = {
        disko.devices.disk.main = {
          type = "disk";
          # set with `disko-install --disk main` when formatting
          device = lib.mkDefault "/dev/disk/by-id/you-forgot-the-disk-flag";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = disk.bootSize;
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [
                    "fmask=0022"
                    "dmask=0022"
                  ];
                };
              };
              root = {
                size = "100%";
                content = if disk.encrypted then luks else btrfs;
              };
            };
          };
        };
      };
    };
}
