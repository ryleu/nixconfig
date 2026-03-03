{ pkgs, ... }:

{
  home.packages = with pkgs; [
    undollar
    silver-searcher
    ripgrep
    bun
    unzip
    jq
    gh
    nix-index
    wget
    nix-search
    nixfmt-rfc-style
    ffmpeg-full
    wl-clipboard
    fastfetch
    btop-rocm
    aria2
    yt-dlp
    tmux
    packwiz
    blahaj
    whipper
  ];
}
