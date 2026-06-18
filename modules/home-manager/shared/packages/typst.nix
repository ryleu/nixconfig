{ pkgs, ... }:
{
  home.packages = with pkgs; [
    typst
    typstyle
    typst-live
  ];

  programs.zathura.enable = true;
}
