{ inputs, pkgs, ... }:
{
  imports = [
    ./ryleu
  ];

  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
