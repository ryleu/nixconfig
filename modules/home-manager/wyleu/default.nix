{ ... }:
{
  # basic home manager stuff
  home = {
    username = "wyleu";
    homeDirectory = "/home/wyleu";
    stateVersion = "25.11";
  };

  imports = [
    # personal configuration
    ./browser.nix
    ./packages.nix
  ];
}
