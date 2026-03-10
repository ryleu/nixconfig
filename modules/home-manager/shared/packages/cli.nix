{ pkgs, ... }:

{
  home.packages = with pkgs; [
    undollar
    silver-searcher
    ripgrep
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
    tmux
    dig
    pciutils
    bat

    # tui
    spotify-player
    impala
    bluetui
  ];
}
