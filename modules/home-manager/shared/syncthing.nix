{
  config,
  lib,
  osConfig,
  ...
}:
let
  hostname = osConfig.networking.hostName;
  user = config.home.username;
  home = config.home.homeDirectory;
  enableSyncthing =
    (builtins.pathExists ../../nixos/agenix/${user}/syncthing-cert-${hostname}.age)
    && (builtins.pathExists ../../nixos/agenix/${user}/syncthing-key-${hostname}.age);
in
{
  services.syncthing = {
    # ensure we have the required key and cert
    enable = lib.mkIf enableSyncthing true;

    # https://wiki.nixos.org/wiki/Syncthing#Declarative_node_IDs
    cert = "/run/agenix/syncthing-cert-${user}";
    key = "/run/agenix/syncthing-key-${user}";

    settings = {
      devices."monument".id = "XJSOXJB-CWXBQKK-Y55S4JK-MRHTP3Q-3G7M5CX-ELBQYOG-3VREJX6-DTPB5AY";

      folders = {
        # device-specific
        "${user}-${hostname}" = {
          path = "${home}";
          devices = [
            {
              name = "monument";
              encryptionPasswordFile = "/run/agenix/syncthing-password-${user}";
            }
          ];
          type = "sendonly";
        };

        # shared across all devices
        "${user}" = {
          path = "${home}/Sync";
          devices = [
            {
              name = "monument";
              encryptionPasswordFile = "/run/agenix/syncthing-password-${user}";
            }
          ];
          type = "sendreceive";
        };
      };
    };
  };

  home.file.".stignore" = {
    enable = enableSyncthing;
    force = true;
    text = ''
      // folders i want to keep
      !/Code
      !/Documents
      !/Music
      !/Pictures
      !/Videos
      !/.local/share/PrismLauncher/instances
      !/.config/zen/default

      // ignore things that can cause issues to sync
      (?d).direnv
      (?d).stfolder
      /Sync

      // ignore everything else
      /**
    '';
  };
}
