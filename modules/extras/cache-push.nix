# push to the binary cache with attic
{
  flake.modules.homeManager.cache-push = {
    imports = [
      (
        { config, ... }:
        let
          user = config.home.username;
        in
        {
          xdg.configFile."attic/config.toml".text = ''
            default-server = "redoak"

            [servers.redoak]
            endpoint = "https://cache.ryleu.me"
            token-file = "/run/agenix/attic-token-${user}"
          '';
        }
      )
      ({ pkgs, ... }: { home.packages = [ pkgs.attic-client ]; })
    ];
  };

  flake.modules.nixos.cache-push = {
    age.secrets.attic-token-ryleu = {
      file = ../../secrets/ryleu-attic-token.age;
      mode = "600";
      owner = "ryleu";
      group = "users";
    };
  };
}
