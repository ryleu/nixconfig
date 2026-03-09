{ pkgs, ... }:
{
  home.packages = with pkgs; [
    adwaita-qt6
    adwaita-qt
  ];

  qt = {
    enable = true;

    kde.settings = { };

    platformTheme.name = "adwaita";

    style = {
      name = "adwaita-dark";
    };
  };
}
