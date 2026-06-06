{
  flake.modules.nixos.base = {
    nix = {
      distributedBuilds = true;
      settings = {
        builders-use-substitutes = true;
        trusted-users = [ "remotebuild" ];
      };
    };

    services.openssh.settings.AllowUsers = [ "remotebuild" ];
  };
}
