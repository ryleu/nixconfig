{ ... }:
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
    ];
    search = [
      # tailscale again
      "fawn-stonecat.ts.net"
      "tail08389.ts.net"
    ];
  };
  services.tailscale.enable = true;
}
