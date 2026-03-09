{ inputs, pkgs, ... }:
{
  imports = [
    ./ryleu
    ./wyleu
  ];

  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
