{
  flake.modules.nixos.work =
    { lib, ... }:
    {
      # local docker registry
      services.dockerRegistry = {
        enable = true;
        port = 5000;
        listenAddress = "127.0.0.1";
        enableGarbageCollect = true;
        garbageCollectDates = "weekly";
      };

      systemd = {
        # only start when wyleu logs in
        services.docker-registry = {
          wantedBy = lib.mkForce [ "wyleu-work.target" ];
          partOf = [ "wyleu-work.target" ];
        };

        # docker-registry needs its own user and group on its state dir
        tmpfiles.settings."10-docker-registry-wipe"."/var/lib/docker-registry".d = {
          user = "docker-registry";
          group = "docker-registry";
          mode = "0750";
        };
      };
    };
}
