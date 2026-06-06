{
  flake.modules.nixos.base.nix = {
    optimise = {
      automatic = true;
      dates = [ "09:00" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 90d";
    };
  };
}
