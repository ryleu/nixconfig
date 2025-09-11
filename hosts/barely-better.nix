{ ... }:

{
  imports = [
    ../conf/laptop.nix
    ../packages/quartus.nix
  ];

  networking.hostName = "barely-better";
}
