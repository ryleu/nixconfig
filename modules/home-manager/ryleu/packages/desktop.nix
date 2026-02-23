{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      hyprpolkitagent
      waybar
      grimblast
      libreoffice
      adwaita-qt6
      adwaita-qt
      glib
      gsettings-desktop-schemas
      xdg-desktop-portal
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gnome
    ];
  };

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

  qt = {
    enable = true;

    kde.settings = { };

    platformTheme.name = "adwaita";

    style = {
      name = "adwaita-dark";
    };
  };
}
