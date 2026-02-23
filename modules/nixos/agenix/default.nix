{ inputs, pkgs, ... }:
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  age.secrets = {
    # when you have secrets, put them here like this
    #   my-secret.file = ./my-secret.age;
    # they can later be accessed like this
    #   config.age.secrets.my-secret.path
    id_ed25519-key = {
      file = ./id_ed25519-key.age;
      path = "/home/ryleu/.ssh/id_ed25519";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    redoak-key = {
      file = ./redoak-key.age;
      path = "/home/ryleu/.ssh/redoak";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    clucky-key = {
      file = ./clucky-key.age;
      path = "/home/ryleu/.ssh/clucky";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    monument-key = {
      file = ./monument-key.age;
      path = "/home/ryleu/.ssh/monument";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    proxy-key = {
      file = ./proxy-key.age;
      path = "/home/ryleu/.ssh/proxy";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    voron-key = {
      file = ./voron-key.age;
      path = "/home/ryleu/.ssh/voron";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    ripi-key = {
      file = ./ripi-key.age;
      path = "/home/ryleu/.ssh/ripi";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    github-key = {
      file = ./github-key.age;
      path = "/home/ryleu/.ssh/github";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    remotebuild-key = {
      file = ./remotebuild-key.age;
      path = "/root/.ssh/remotebuild";
      mode = "600";
      owner = "root";
      group = "root";
    };

    cosign-key = {
      file = ./cosign-key.age;
      path = "/home/ryleu/.cosign/cosign.key";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };
  };
}
