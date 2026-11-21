# networkd setup
{
  flake.modules.nixos.network-networkd = {
    systemd.network.enable = true;
    networking = {
      # networkd handles DHCP and conflicts with networkmanager
      networkmanager.enable = false;
      useDHCP = false;
    };
  };
}
