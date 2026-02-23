{ ... }:

{
  imports = [
    ../laptop.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "barely-better";
}
