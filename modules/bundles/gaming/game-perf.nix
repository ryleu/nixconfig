# performance mode and performance monitor
{
  flake.modules.nixos.gaming =
    { pkgs, ... }:
    {
      programs.gamemode.enable = true;
      environment.systemPackages = [ pkgs.mangohud ];
    };
}
