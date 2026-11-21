{
  flake.modules.nixos.base = {
    # accounts come from the flake only
    users.mutableUsers = false;
  };
}
