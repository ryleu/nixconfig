{ pkgs, ... }:
{
  home.packages = with pkgs; [
    yt-dlp
    packwiz
    blahaj
    whipper
    bun
  ];
}
