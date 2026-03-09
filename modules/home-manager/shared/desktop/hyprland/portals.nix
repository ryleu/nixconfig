{ pkgs, ... }:
{
  home.packages = with pkgs; [
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gnome
  ];

  xdg = {
    portal = {
      enable = true;
      config = {
        common.default = [
          "hyprland"
          "gtk"
        ];
      };
    };
  };
}
