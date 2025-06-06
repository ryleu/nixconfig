{ config, pkgs, inputs, ... }:

{
  imports = [
    ../conf/desktop.nix
  ];

  networking.hostName = "rectangle";

  # amd shit
  services.xserver = {
    videoDrivers = [ "amdgpu" ];
  };
  boot = {
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [ "i2c-dev" "i2c-piix4" ];
  };

  # additional storage
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
}
