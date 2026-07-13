{ pkgs, mkTuiLauncher, ... }:

{
  home.packages = with pkgs; [
    undollar
    comma
    silver-searcher
    unzip
    nix-search
    nixfmt
    ffmpeg-full
    wl-clipboard
    wget
    dig
    pciutils
    copyparty
    secretspec

    # tui
    impala
    bluetui
  ];

  xdg.desktopEntries = {
    spotify-player = mkTuiLauncher "Spotify" pkgs.spotify-player;
    impala = mkTuiLauncher "WiFi" pkgs.impala;
    bluetui = mkTuiLauncher "Bluetooth" pkgs.bluetui;
    btop = mkTuiLauncher "System Monitor" pkgs.btop-rocm;
  };

  programs = {
    distrobox.enable = true;
    aria2.enable = true;
    ripgrep.enable = true;
    jq.enable = true;
    gh.enable = true;
    nix-index.enable = true;
    fastfetch.enable = true;
    tmux.enable = true;
    bat.enable = true;
    spotify-player.enable = true;
    btop = {
      enable = true;
      package = pkgs.btop-rocm;
    };
  };
}
