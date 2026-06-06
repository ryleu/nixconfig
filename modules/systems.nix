{ config, lib, ... }:
{
  systems = lib.mapAttrsToList (
    _name: nixos: nixos.pkgs.stdenv.hostPlatform.system
  ) config.flake.nixosConfigurations;
}
