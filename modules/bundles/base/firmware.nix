{
  flake.modules.nixos.base = {
    # firmware updater
    services.fwupd.enable = true;
  };
}
