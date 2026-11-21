# thinkpad for dev + work
{
  hosts.stela = {
    stateVersion = "24.11";

    parts = {
      base = { };
      desktop = { };
      dev = { };
      work = { };
      gaming = { };

      session.kind = "greeter";
      network = {
        # networkmanager was having issues waking from suspend
        stack = "networkd";
        wifi = "iwd";
      };
      disk.encrypted = true;

      printing = { };
      power-keys = { };
      fingerprint = { };
      face-unlock.camera = "/dev/v4l/by-path/pci-0000:c4:00.4-usb-0:1:1.2-video-index0";
      bitwarden-bridge = { };
      music = { };
    };

    users = {
      # personal account
      ryleu.parts = {
        ryleu-keys = { };
        ryleu-browser = { };
        ryleu-apps = { };
        discord = { };
        minecraft = { };
        ebooks = { };
        cache-push = { };
        syncthing = {
          # TODO: migrate to new hostname
          folderName = "ethernet-port";
          cert = ../../../secrets/ryleu-syncthing-cert-stela.age;
          key = ../../../secrets/ryleu-syncthing-key-stela.age;
          password = ../../../secrets/ryleu-syncthing-password.age;
        };
      };

      # work account
      wyleu.parts = {
        wyleu-keys = { };
        cac-browser = { };
        horizon = { };
        work-tools = { };
      };
    };
  };
}
