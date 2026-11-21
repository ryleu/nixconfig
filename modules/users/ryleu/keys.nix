{
  flake.modules.homeManager.ryleu-keys =
    _:

    {
      # user-specific ssh config
      programs.ssh = {
        settings = {
          "github.com" = {
            HostName = "github.com";
            User = "git";
            IdentityFile = "~/.ssh/github";
            IdentitiesOnly = true;
          };

          "ripi" = {
            HostName = "ripi";
            User = "ryleu";
            IdentityFile = "~/.ssh/ripi";
            IdentitiesOnly = true;
          };

          "redoak" = {
            HostName = "100.65.152.98";
            User = "willow";
            IdentityFile = "~/.ssh/redoak";
            IdentitiesOnly = false;
          };

          "proxy" = {
            HostName = "proxy";
            User = "ryleu";
            IdentityFile = "~/.ssh/proxy";
            IdentitiesOnly = true;
          };

          "monument.lan" = {
            HostName = "192.168.1.210";
            User = "truenas_admin";
            IdentityFile = "~/.ssh/monument";
            IdentitiesOnly = true;
          };

          "clucky" = {
            HostName = "192.168.1.69";
            User = "clucky";
          };

          "spotipi" = {
            HostName = "spotipi";
            User = "ryleu";
            IdentityFile = "~/.ssh/github";
            IdentitiesOnly = true;
          };
        };
      };
    };

  flake.modules.nixos.ryleu-keys =
    let
      secrets = ../../../secrets;
    in
    {
      # user-specific agenix config
      age.secrets = {
        id_ed25519-key-ryleu = {
          file = secrets + "/ryleu-id_ed25519-key.age";
          path = "/home/ryleu/.ssh/id_ed25519";
          mode = "600";
          owner = "ryleu";
          group = "users";
        };
        redoak-key-ryleu = {
          file = secrets + "/ryleu-redoak-key.age";
          path = "/home/ryleu/.ssh/redoak";
          mode = "600";
          owner = "ryleu";
          group = "users";
        };
        monument-key-ryleu = {
          file = secrets + "/ryleu-monument-key.age";
          path = "/home/ryleu/.ssh/monument";
          mode = "600";
          owner = "ryleu";
          group = "users";
        };
        proxy-key-ryleu = {
          file = secrets + "/ryleu-proxy-key.age";
          path = "/home/ryleu/.ssh/proxy";
          mode = "600";
          owner = "ryleu";
          group = "users";
        };
        ripi-key-ryleu = {
          file = secrets + "/ryleu-ripi-key.age";
          path = "/home/ryleu/.ssh/ripi";
          mode = "600";
          owner = "ryleu";
          group = "users";
        };
        github-key-ryleu = {
          file = secrets + "/ryleu-github-key.age";
          path = "/home/ryleu/.ssh/github";
          mode = "600";
          owner = "ryleu";
          group = "users";
        };

        cosign-key-ryleu = {
          file = secrets + "/ryleu-cosign-key.age";
          path = "/home/ryleu/.cosign/cosign.key";
          mode = "600";
          owner = "ryleu";
          group = "users";
        };
      };
    };
}
