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
    spotify-player = mkTuiLauncher "Spotify" pkgs.spotify-player;
    impala = mkTuiLauncher "WiFi" pkgs.impala;
    bluetui = mkTuiLauncher "Bluetooth" pkgs.bluetui;
    btop = mkTuiLauncher "System Monitor" pkgs.btop-rocm;
  };

  programs.distrobox.enable = true;
}
