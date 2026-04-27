{ ... }:
{
  # basic home manager stuff
  home = {
    username = "ryleu";
    homeDirectory = "/home/ryleu";
    stateVersion = "25.11";
  };

  imports = [
    # personal configuration
    ./browser.nix
    ./git.nix
    ./packages
    ./ssh.nix
  ];
}
