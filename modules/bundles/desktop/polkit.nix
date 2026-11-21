# the graphical prompt for privilege requests
{
  flake.modules.homeManager.desktop = {
    services.hyprpolkitagent.enable = true;
  };

  flake.modules.nixos.desktop = {
    security.polkit.enable = true;
  };
}
