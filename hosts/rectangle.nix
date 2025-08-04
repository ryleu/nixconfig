{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ../conf/desktop.nix
  ];

  services = {
    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="8087", ATTRS{idProduct}=="0029", GROUP="plugdev", MODE="0660", TAG+="uaccess"
    '';
  };

  users.users.ryleu.openssh.authorizedKeys.keys = import ../secrets/authorized_keys.nix;

  environment.systemPackages = with pkgs; [
    lact
  ];
  systemd = {
    services.lactd.enable = true;

    packages = with pkgs; [
      lact
    ];
  };

  networking.hostName = "rectangle";

  # amd shit
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      amf
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };
  boot = {
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [
      "i2c-dev"
      "i2c-piix4"
    ];
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
  programs = {
    zsh.enable = true;

    # enable hyprland
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    hyprlock.enable = true;

    steam = {
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}
