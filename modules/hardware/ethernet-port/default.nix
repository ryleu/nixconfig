{ pkgs, inputs, ... }:
{
  imports = [
    ../laptop.nix
    ./hardware-configuration.nix

    # technically i have a gen 6, but this is close enough
    inputs.hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen5
  ];

  # networking
  networking.hostName = "ethernet-port";
  systemd.network.wait-online.enable = false; # don't need networking to boot a laptop
  systemd.network.networks = {
    "10-enp195s0f0-dhcp.network" = {
      matchConfig.Name = "enp195s0f0";
      networkConfig = {
        DHCP = "yes";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "no";
    };
    "10-wlan0-dhcp.network" = {
      matchConfig.Name = "wlan0";
      networkConfig = {
        DHCP = "yes";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "no";
    };
  };

  # smart card
  services.pcscd.enable = true;
  environment.systemPackages = with pkgs; [
    pcsclite
    pcsc-tools
  ];

  # fingerprint scanner
  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-goodix;
    };
  };
}
