{ pkgs, ... }:

{
  home.packages = with pkgs; [
    undollar
    comma
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
    copyparty

    # tui
    spotify-player
    impala
    bluetui
  ];
}
