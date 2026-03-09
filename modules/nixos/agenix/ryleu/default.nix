{
  inputs,
  config,
  lib,
  ...
}:
let
  hostName = "${config.networking.hostName}";
in
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  age.secrets = {
    # when you have secrets, put them here like this
    #   my-secret.file = ./my-secret.age;
    # they can later be accessed like this
    #   config.age.secrets.my-secret.path
    id_ed25519-key-ryleu = {
      file = ./id_ed25519-key.age;
      path = "/home/ryleu/.ssh/id_ed25519";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    redoak-key-ryleu = {
      file = ./redoak-key.age;
      path = "/home/ryleu/.ssh/redoak";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    monument-key-ryleu = {
      file = ./monument-key.age;
      path = "/home/ryleu/.ssh/monument";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    proxy-key-ryleu = {
      file = ./proxy-key.age;
      path = "/home/ryleu/.ssh/proxy";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    ripi-key-ryleu = {
      file = ./ripi-key.age;
      path = "/home/ryleu/.ssh/ripi";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    github-key-ryleu = {
      file = ./github-key.age;
      path = "/home/ryleu/.ssh/github";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    cosign-key-ryleu = {
      file = ./cosign-key.age;
      path = "/home/ryleu/.cosign/cosign.key";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    syncthing-password-ryleu = {
      file = ./syncthing-password.age;
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    syncthing-cert-ryleu = lib.mkIf (builtins.pathExists ./syncthing-cert-${hostName}.age) {
      file = ./syncthing-cert-${hostName}.age;
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    syncthing-key-ryleu = lib.mkIf (builtins.pathExists ./syncthing-key-${hostName}.age) {
      file = ./syncthing-key-${hostName}.age;
      mode = "600";
      owner = "ryleu";
      group = "users";
    };
  };
}
