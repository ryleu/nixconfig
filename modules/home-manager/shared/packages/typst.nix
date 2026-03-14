{ pkgs, ... }:
{
  home.packages = with pkgs; [
    typst
    typstyle
    typst-live
    zathura
  ];
}
