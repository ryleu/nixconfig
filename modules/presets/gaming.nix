{
  flake.modules.nixos.gaming =
    { lib, pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = lib.mkDefault false;
        dedicatedServer.openFirewall = lib.mkDefault false;
        package = pkgs.steam.override {
          extraPkgs =
            pkgs: with pkgs; [
              libkrb5
              keyutils
              gamescope
            ];
        };
      };

      # game servers
      networking.firewall.allowedTCPPorts = [
        25565 # minecraft
      ];

      # controllers
      services.udev.packages = with pkgs; [ steam-devices-udev-rules ];
    };

  flake.modules.homeManager.gaming =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        prismlauncher
        vintagestory
      ];
    };
}
