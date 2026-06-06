{
  flake.modules.nixos.base =
    { lib, pkgs, ... }:
    {
      systemd.network.enable = true;

      networking = {
        networkmanager.enable = false;
        useDHCP = false;
        wireless.enable = false;

        # wifi via iwd
        wireless.iwd = {
          enable = true;
          settings = {
            IPv6.Enabled = true;
            Settings = {
              AutoConnect = true;
              # fixes some issues with wpa2
              ControlPortOverNL80211 = false;
            };
          };
        };

        firewall = {
          enable = true;
          allowedTCPPorts = [
            3923 # copyparty
          ];
          # ROS2 (domain id > 2 will not work)
          allowedUDPPortRanges = [
            {
              from = 7400;
              to = 7999;
            }
          ];
        };

        nameservers = [
          # cloudflare
          "1.1.1.3"
          "1.0.0.3"
          # magicdns for tailscale
          "2606:4700:4700::1113"
          "2606:4700:4700::1003"
        ];
        search = [
          # tailscale
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

      # auto CAN adapter setup
      services.udev.extraRules = lib.mkOrder 1000 ''
        SUBSYSTEM=="net", ACTION=="add", KERNEL=="can*", \
          RUN+="${pkgs.iproute2}/bin/ip link set %k type can bitrate 1000000", \
          RUN+="${pkgs.iproute2}/bin/ip link set up %k"
      '';
    };
}
