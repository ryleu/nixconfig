{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ../conf/laptop.nix
  ];

  networking.hostName = "mathrock";
}
