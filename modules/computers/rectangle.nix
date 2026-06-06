{ config, ... }:
{
  configurations.nixos.rectangle.module = {
    imports = with config.flake.modules.nixos; [
      base
      gui
      amd-graphics
      desktop
      gaming
      server
      ryleu
    ];

    networking.hostName = "rectangle";
    nixpkgs.hostPlatform = "x86_64-linux";

    # rectangle storage
    fileSystems = {
      "/mnt/hdd" = {
        device = "/dev/disk/by-uuid/1400b78a-afe6-4764-ab36-e23cb033455c";
        fsType = "btrfs";
        options = [
          "defaults"
          "nofail"
        ];
      };
      "/mnt/ssd" = {
        device = "/dev/disk/by-uuid/09ba989e-ef6a-413b-bb4c-21923d441b8b";
        fsType = "btrfs";
        options = [
          "defaults"
          "nofail"
        ];
      };
    };

    # usb bluetooth adapter
    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="8087", ATTRS{idProduct}=="0029", GROUP="plugdev", MODE="0660", TAG+="uaccess"
    '';

    home-manager.users.ryleu.imports = with config.flake.modules.homeManager; [
      gui
      gaming
    ];
  };
}
