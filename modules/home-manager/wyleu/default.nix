{ ... }:
{
  # basic home manager stuff
  home = {
    username = "wyleu";
    homeDirectory = "/home/wyleu";
    stateVersion = "25.11";
  };

  imports = [
    ./browser.nix
    ./git.nix
    ./packages.nix
    ./ssh.nix
  ];
}
