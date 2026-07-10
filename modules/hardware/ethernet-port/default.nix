{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../laptop.nix
    ./hardware-configuration.nix

    # technically i have a gen 6, but this is close enough
    inputs.hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen5
  ];

  # docker state on its own btrfs subvolume so it can be wiped on boot
  fileSystems."/var/lib/docker" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "btrfs";
    options = [ "subvol=docker" ];
  };
  fileSystems."/var/lib/docker-registry" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "btrfs";
    options = [ "subvol=docker-registry" ];
  };

  # wipe docker state on every boot
  boot.initrd.systemd.services.wipe-docker-state = {
    description = "Wipe docker + docker-registry btrfs subvolumes on boot";
    wantedBy = [ "initrd.target" ];
    after = [ "dev-disk-by\\x2dlabel-NIXROOT.device" ];
    before = [ "sysroot.mount" ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      mkdir -p /btrfs_tmp
      mount -t btrfs -o subvolid=5 /dev/disk/by-label/NIXROOT /btrfs_tmp
      for sv in docker docker-registry; do
        if [ -d "/btrfs_tmp/$sv" ]; then
          btrfs subvolume delete --recursive "/btrfs_tmp/$sv" 2>/dev/null \
            || btrfs subvolume delete "/btrfs_tmp/$sv"
        fi
        btrfs subvolume create "/btrfs_tmp/$sv"
      done
      umount /btrfs_tmp
    '';
  };

  # fresh subvolume have root:root, docker-registry needs its own user and group
  systemd.tmpfiles.settings."10-docker-registry-wipe"."/var/lib/docker-registry".d = {
    user = "docker-registry";
    group = "docker-registry";
    mode = "0750";
  };

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
    opensc
    cacert
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
