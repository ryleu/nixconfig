{ ... }:
{
  imports = [
    ./browser.nix
    ./desktop
    ./editor.nix
    ./git.nix
    ./packages
    ./shell.nix
    ./syncthing.nix
    ./zed.nix
  ];
}
