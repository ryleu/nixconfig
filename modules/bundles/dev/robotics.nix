{
  flake.modules.nixos.dev =
    { pkgs, lib, ... }:
    {
      # open ports for ROS2
      # domain id > 2 will not work
      networking.firewall.allowedUDPPortRanges = [
        {
          from = 7400;
          to = 7999;
        }
      ];

      # bring up any CAN interface at 1 Mbit/s
      services.udev.extraRules = lib.mkOrder 1000 ''
        SUBSYSTEM=="net", ACTION=="add", KERNEL=="can*", \
          RUN+="${pkgs.iproute2}/bin/ip link set %k type can bitrate 1000000", \
          RUN+="${pkgs.iproute2}/bin/ip link set up %k"
      '';
    };
}
