{
  flake.modules.nixos.base = {
    zramSwap.enable = true;
    systemd.oomd.enable = true;
  };
}
