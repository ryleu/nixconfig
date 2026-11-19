{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ../laptop.nix
    ./hardware-configuration.nix
    ./biometrics.nix

    # technically i have a gen 6, but this is close enough
    inputs.hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen5
  ];

  users.users.ryleu.extraGroups = [
    "video"
    "render"
  ];

  # docker-registry needs its own user and group on its state dir
  systemd.tmpfiles.settings."10-docker-registry-wipe"."/var/lib/docker-registry".d = {
    user = "docker-registry";
    group = "docker-registry";
    mode = "0750";
  };

  # disable ssh
  services.openssh.enable = lib.mkForce false;
  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

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
  services.avahi.allowInterfaces = [
    "enp195s0f0"
    "wlan0"
  ];

  # smart card
  services.pcscd.enable = true;
  environment.systemPackages = with pkgs; [
    pcsclite
    pcsc-tools
    opensc
    cacert
  ];
}
