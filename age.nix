{ ... }:
{
  # secrets
  age.secrets = {
    # when you have secrets, put them here like this
    #   my-secret.file = ./secrets/my-secret.age;
    # they can later be accessed like this
    #   config.age.secrets.my-secret.path
    id_ed25519-key = {
      file = ./secrets/id_ed25519-key.age;
      path = "/home/ryleu/.ssh/id_ed25519";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    redoak-key = {
      file = ./secrets/redoak-key.age;
      path = "/home/ryleu/.ssh/redoak";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    clucky-key = {
      file = ./secrets/clucky-key.age;
      path = "/home/ryleu/.ssh/clucky";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    monument-key = {
      file = ./secrets/monument-key.age;
      path = "/home/ryleu/.ssh/monument";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    proxy-key = {
      file = ./secrets/proxy-key.age;
      path = "/home/ryleu/.ssh/proxy";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    voron-key = {
      file = ./secrets/voron-key.age;
      path = "/home/ryleu/.ssh/voron";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    ripi-key = {
      file = ./secrets/ripi-key.age;
      path = "/home/ryleu/.ssh/ripi";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    github-key = {
      file = ./secrets/github-key.age;
      path = "/home/ryleu/.ssh/github";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    remotebuild-key = {
      file = ./secrets/remotebuild-key.age;
      path = "/root/.ssh/remotebuild";
      mode = "600";
      owner = "root";
      group = "root";
    };
  };
}
