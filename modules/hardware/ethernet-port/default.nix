{ inputs, ... }:

{
  imports = [
    ../laptop.nix
    ./hardware-configuration.nix
    ./fingerprint.nix
    ./smart-card.nix

    # technically i have a gen 6, but this is close enough
    inputs.hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen5
  ];

  networking.hostName = "ethernet-port";
}
