{ pkgs, ... }:
{
  home.packages = with pkgs; [
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gnome
  ];

  xdg = {
    userDirs.enable = true;

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
