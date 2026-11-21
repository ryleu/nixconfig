{
  flake.modules.nixos.base = {
    # ports are opened by the features that need them
    networking.firewall.enable = true;
  };
}
