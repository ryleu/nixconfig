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
