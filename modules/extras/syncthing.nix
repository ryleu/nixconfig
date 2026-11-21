# automatically sync files to monument via syncthing
{
  settings.syncthing =
    { lib, ... }:
    let
      secret =
        description:
        lib.mkOption {
          type = lib.types.path;
          inherit description;
        };
    in
    {
      options = {
        folderName = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "The share name of the synced folder.";
        };

        guiPort = lib.mkOption {
          type = lib.types.port;
          default = 8384;
          description = "The local management interface port.";
        };

        # https://wiki.nixos.org/wiki/Syncthing#Declarative_node_IDs
        cert = secret "The age file containing the certificate.";
        key = secret "The age file containing the key for the certificate.";
        password = secret "The age file containing the password for the encrypted folder.";
      };
    };

  flake.modules.homeManager.syncthing =
    {
      config,
      osConfig,
      ...
    }:
    let
      hostname = osConfig.networking.hostName;
      user = config.home.username;
      home = config.home.homeDirectory;
      inherit (osConfig.age) secrets;
      folderName =
        if config.parts.syncthing.folderName != null then config.parts.syncthing.folderName else hostname;
    in
    {
      services.syncthing = {
        enable = true;

        guiAddress = "127.0.0.1:${toString config.parts.syncthing.guiPort}";

        cert = secrets."syncthing-cert-${user}".path;
        key = secrets."syncthing-key-${user}".path;

        settings = {
          devices."monument".id = "XJSOXJB-CWXBQKK-Y55S4JK-MRHTP3Q-3G7M5CX-ELBQYOG-3VREJX6-DTPB5AY";

          folders = {
            # device-specific
            "${user}-${folderName}" = {
              path = "${home}";
              devices = [
                {
                  name = "monument";
                  encryptionPasswordFile = secrets."syncthing-password-${user}".path;
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
                  encryptionPasswordFile = secrets."syncthing-password-${user}".path;
                }
              ];
              type = "sendreceive";
            };
          };
        };
      };

      home.file.".stignore" = {
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
    };

  # declare agenix secrets
  flake.modules.nixos.syncthing =
    { config, lib, ... }:
    let
      users = lib.filterAttrs (_: user: user.parts ? syncthing) config.home-manager.users;

      secretsFor =
        name: user:
        let
          mine = file: {
            inherit file;
            mode = "600";
            owner = name;
            group = "users";
          };
        in
        {
          "syncthing-cert-${name}" = mine user.parts.syncthing.cert;
          "syncthing-key-${name}" = mine user.parts.syncthing.key;
          "syncthing-password-${name}" = mine user.parts.syncthing.password;
        };
    in
    {
      age.secrets = lib.concatMapAttrs secretsFor users;
    };
}
