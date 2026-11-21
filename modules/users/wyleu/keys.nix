{
  flake.modules.homeManager.wyleu-keys =
    _:

    {
      # hosts this user connects to. the shared defaults are in ssh-client
      programs.ssh = {
        settings = {
          "gitlab.com" = {
            HostName = "gitlab.com";
            User = "git";
            IdentityFile = "~/.ssh/id_ed25519";
            IdentitiesOnly = true;
          };
        };
      };
    };

  flake.modules.nixos.wyleu-keys = {
    age.secrets.id_ed25519-key-wyleu = {
      file = ../../../secrets/wyleu-id_ed25519-key.age;
      path = "/home/wyleu/.ssh/id_ed25519";
      mode = "600";
      owner = "wyleu";
      group = "users";
    };
  };
}
