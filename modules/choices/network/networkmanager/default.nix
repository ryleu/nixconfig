# networkmanager setup, mostly for Steam Big Picture
{
  flake.modules.nixos.network-networkmanager =
    { config, lib, ... }:
    {
      networking = {
        networkmanager = {
          enable = true;
          wifi.backend = lib.mkIf (config.parts.network.wifi == "iwd") "iwd";
        };
        # networkmanager handles DHCP
        useDHCP = false;
      };

      # let all users configure networks
      users.groups.networkmanager.members = builtins.attrNames config.home-manager.users;
    };
}
