{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    packwiz
    whipper
    xwayland-satellite
  ];

  programs.yt-dlp.enable = true;
  programs.bun.enable = true;

  programs.zsh.completionInit = lib.mkAfter ''
    eval `${pkgs.packwiz}/bin/packwiz completion zsh`
  '';
}
