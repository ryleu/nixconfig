# hardware-specifc config for stela
{ inputs, ... }:
{
  hosts.stela.modules = [
    (
      {
        modulesPath,
        ...
      }:
      {
        imports = [
          inputs.hardware.nixosModules.common-pc-ssd

          # technically i have a gen 6, but this is close enough
          inputs.hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen5
          (modulesPath + "/installer/scan/not-detected.nix")
        ];

        services.logind.settings.Login = {
          HandleLidSwitch = "suspend";
          HandleLidSwitchDocked = "ignore";
          HandleLidSwitchExternalPower = "suspend";
        };

        # suspend works great. don't want to hibernate because i'd need a 48-gig swap
        systemd.sleep.settings.Sleep = {
          AllowHibernation = "no";
          AllowSuspendThenHibernate = "no";
          AllowHybridSleep = "no";
        };

        # results of hardware scan from nixos-generate-config
        boot = {
          kernelModules = [ "kvm-amd" ];

          initrd = {
            availableKernelModules = [
              "nvme"
              "xhci_pci"
              "thunderbolt"
              "usbhid"
              "usb_storage"
              "sd_mod"
            ];
          };
        };

        nixpkgs.hostPlatform = "x86_64-linux";
        hardware.cpu.amd.updateMicrocode = true;
      }
    )
  ];
}
