{
  flake.modules.nixos.dev =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.docker-buildx ];

      virtualisation.docker = {
        enable = true;

        # keep docker's disk usage in check (soft limit)
        autoPrune = {
          enable = true;
          dates = "weekly";
          flags = [
            "--all"
            "--volumes"
          ];
        };
        daemon.settings = {
          # cap the build cache
          builder.gc = {
            enabled = true;
            defaultKeepStorage = "20GB";
          };
          # cap container logs
          log-driver = "json-file";
          log-opts = {
            max-size = "50m";
            max-file = "3";
          };
        };
      };
    };
}
