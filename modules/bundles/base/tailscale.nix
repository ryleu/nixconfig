{
  flake.modules.nixos.base = {
    services.tailscale = {
      enable = true;
      # accept DNS config
      extraSetFlags = [ "--accept-dns=true" ];
    };
  };
}
