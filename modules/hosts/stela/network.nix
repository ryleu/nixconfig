# define network interfaces
{
  hosts.stela.modules = [
    {
      systemd.network.wait-online.enable = false; # don't need networking to boot a laptop
      systemd.network.networks = {
        # built in ethernet port
        "10-enp195s0f0-dhcp.network" = {
          matchConfig.Name = "enp195s0f0";
          networkConfig = {
            DHCP = "yes";
            IPv6AcceptRA = true;
          };
          linkConfig.RequiredForOnline = "no";
        };
        # built in wifi 7 chip
        "10-wlan0-dhcp.network" = {
          matchConfig.Name = "wlan0";
          networkConfig = {
            DHCP = "yes";
            IPv6AcceptRA = true;
          };
          linkConfig.RequiredForOnline = "no";
        };
      };
      # only want discovery over existing interfaces
      services.avahi.settings.server.allow-interfaces = [
        "enp195s0f0"
        "wlan0"
      ];
    }
  ];
}
