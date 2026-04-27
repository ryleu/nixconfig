{ config, lib, osConfig, ... }:
let
  hostName = osConfig.networking.hostName;
  user = config.home.username;
  home = config.home.homeDirectory;
  enableSyncthing =
    (builtins.pathExists ../../nixos/agenix/${user}/syncthing-cert-${hostName}.age)
    && (builtins.pathExists ../../nixos/agenix/${user}/syncthing-key-${hostName}.age);
in
{
  services.syncthing = {
    # ensure we have the required key and cert
    enable = lib.mkIf enableSyncthing true;

    # https://wiki.nixos.org/wiki/Syncthing#Declarative_node_IDs
    cert = "/run/agenix/syncthing-cert-${user}";
    key = "/run/agenix/syncthing-key-${user}";

    settings = {
      devices = {
        "monument".id = "XJSOXJB-CWXBQKK-Y55S4JK-MRHTP3Q-3G7M5CX-ELBQYOG-3VREJX6-DTPB5AY";
      };

      folders =
        builtins.foldl'
          (
            prev: dir:
            prev
            // {
              "${hostName}-${dir}" = {
                path = "${home}/${dir}";
                devices = [
                  {
                    name = "monument";
                    encryptionPasswordFile = "/run/agenix/syncthing-password-${user}";
                  }
                ];
                type = "sendreceive";
              };
            }
          )
          { }
          [
            # folders i care about
            "Code"
            "Desktop"
            "Documents"
            "Music"
            "Pictures"
            "Videos"
          ];
    };
  };
}
