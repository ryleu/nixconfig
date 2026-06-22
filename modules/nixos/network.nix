{ pkgs, lib, ... }:
{
  ## NETWORKING ##
  # enable systemd networkd
  systemd.network.enable = true;
  networking = {
    # disable networkmanager (we use networkd)
    networkmanager.enable = false;
    # disable dhcpcd (we use iwd)
    useDHCP = false;

    # disable wpa supplicant (we use iwd)
    wireless.enable = false;

    # enable iwd
    wireless.iwd = {
      enable = true;
      settings = {
        IPv6.Enabled = true;
        Settings = {
          # auto connect to wifi
          AutoConnect = true;
          # fixes some issues with wpa2
          ControlPortOverNL80211 = false;
        };
      };
    };

    # configure firewall
    firewall = {
      enable = true;
      allowedTCPPorts = [
        25565 # minecraft
        3923 # copyparty
      ];
    }
    // (
      let
        # open ports for ROS2
        # domain id > 2 will not work
        ros2PortRanges = [
          {
            from = 7400;
            to = 7999;
          }
        ];
      in
      {
        allowedUDPPortRanges = ros2PortRanges;
      }
    );

    nameservers = [
      # cloudflare
      "1.1.1.3"
      "1.0.0.3"
      # magicdns for tailscale
      "2606:4700:4700::1113"
      "2606:4700:4700::1003"
      # opennic
      "147.93.130.20"
      "94.247.43.254"
      "194.36.144.87"
      "195.10.195.195"
      "2605:a140:3015:4386::1"
      "2a00:f826:8:1::254"
      "2a03:4000:4d:c92:88c0:96ff:fec6:b9d"
      "2a00:f826:8:2::195"
    ];
    search = [
      # tailscale again
      "fawn-stonecat.ts.net"
      "tail08389.ts.net"
    ];
  };
  services.tailscale.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
  };

  services.udev.extraRules = lib.mkOrder 1000 ''
    SUBSYSTEM=="net", ACTION=="add", KERNEL=="can*", \
      RUN+="${pkgs.iproute2}/bin/ip link set %k type can bitrate 1000000", \
      RUN+="${pkgs.iproute2}/bin/ip link set up %k"
  '';
}
