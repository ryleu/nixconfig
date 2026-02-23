{ ... }:
{
  # basic home manager stuff
  home = {
    username = "ryleu";
    homeDirectory = "/home/ryleu";
    stateVersion = "25.11";
  };

  imports = [
    ./desktop
    ./editor.nix
    ./font.nix
    ./git.nix
    ./packages
    ./shell.nix # has zsh / shell configuration
    ./ssh.nix
    ./zen.nix
  ];
}
