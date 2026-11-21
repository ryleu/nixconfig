{
  flake.modules.nixos.base = {
    zramSwap.enable = true;

    # oomd is on by default but watches nothing until told which slices to
    # watch. these two cover user sessions and system services
    systemd.oomd = {
      enableUserSlices = true;
      enableSystemSlice = true;
    };
  };
}
