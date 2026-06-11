{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    yt-dlp
    packwiz
    blahaj
    whipper
    bun
    xwayland-satellite
  ];

  programs.zsh.completionInit = lib.mkAfter ''
    eval `${pkgs.packwiz}/bin/packwiz completion zsh`
  '';
}
