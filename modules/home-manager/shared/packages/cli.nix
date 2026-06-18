{ pkgs, mkTuiLauncher, ... }:

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
    nixfmt
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

  xdg.desktopEntries = {
    spotify-player = mkTuiLauncher pkgs.spotify-player;
    impala = mkTuiLauncher pkgs.impala;
    bluetui = mkTuiLauncher pkgs.bluetui;
    btop = mkTuiLauncher pkgs.btop-rocm;
  };

  programs.distrobox.enable = true;
}
