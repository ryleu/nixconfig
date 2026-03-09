{ nixos-config, lib, ... }:
let
  hostName = nixos-config.networking.hostName;
  enableSyncthing =
    (builtins.pathExists ../../nixos/agenix/syncthing-cert-${hostName}.age)
    && (builtins.pathExists ../../nixos/agenix/syncthing-key-${hostName}.age);
in
{
  services.syncthing = {
    # ensure we have the required key and cert
    enable = lib.mkIf enableSyncthing true;

    # https://wiki.nixos.org/wiki/Syncthing#Declarative_node_IDs
    cert = "/run/agenix/syncthing-cert-ryleu";
    key = "/run/agenix/syncthing-key-ryleu";

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
                path = "/home/ryleu/${dir}";
                devices = [
                  {
                    name = "monument";
                    encryptionPasswordFile = "/run/agenix/syncthing-password-ryleu";
                  }
                ];
                type = "sendonly";
              };
            }
          )
          { }
          [
            # folders i care about
            "Desktop"
            "Documents"
            "Music"
            "Pictures"
            "Videos"
          ];
    };
  };
}
