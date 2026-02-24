{ ... }:
{
  # basic home manager stuff
  home = {
    username = "ryleu";
    homeDirectory = "/home/ryleu";
    stateVersion = "25.11";
  };

  imports = [
    ./browser.nix
    ./desktop
    ./editor.nix
    ./git.nix
    ./packages
    ./shell.nix # has zsh / shell configuration
    ./ssh.nix
    ./syncthing.nix
  ];
}
