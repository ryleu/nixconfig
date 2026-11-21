# what the board itself needs. from the community docs at
# https://elektricm.github.io/amd-bc250-docs/
{
  hosts.temple.modules = [
    (
      {
        config,
        modulesPath,
        pkgs,
        ...
      }:
      {
        imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

        nixpkgs.hostPlatform = "x86_64-linux";
        hardware.cpu.amd.updateMicrocode = true;
        jovian.hardware.has.amd.gpu = true;

        boot = {
          # from output of `lspci -k`
          initrd.availableKernelModules = [
            "nvme"
            "ahci"
            "xhci_pci"
            "ehci_pci"
            "ohci_pci"
            "usbhid"
            "usb_storage"
            "sd_mod"
          ];
          # latest kernel because this is experimental hardware.
          kernelPackages = pkgs.linuxPackages_latest;

          kernelModules = [
            "kvm-amd"
            "nct6687"
          ];

          # sensor chip is a nuvoton nct6686d. need the correct driver to set fan curves
          extraModulePackages = [ config.boot.kernelPackages.nct6687d ];
          blacklistedKernelModules = [ "nct6683" ];
          # the chip is not on the driver's list of known boards
          extraModprobeConfig = "options nct6687 force=true";
        };

        # suspend is broken as of 2026-11-21
        systemd.targets = {
          sleep.enable = false;
          suspend.enable = false;
          hibernate.enable = false;
          hybrid-sleep.enable = false;
        };
      }
    )
  ];
}
