{
  flake.modules.homeManager.gui =
    { config, pkgs, ... }:
    {
      home.packages = with pkgs; [
        # apps
        vscode-fhs
        (python312.withPackages (
          py: with py; [
            bpython
            numpy
            jupyter
            uv
            pip
            matplotlib
          ]
        ))
        mpv
        spotify
        calibre
        krita
        libreoffice
        blender
        pavucontrol
        bottles
        qdirstat
        logseq
        ungoogled-chromium

        # cli
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

        # typst
        typst
        typstyle
        typst-live
        zathura
      ];

      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-vkcapture
          obs-pipewire-audio-capture
        ];
      };

      # music daemon
      services.mpd = {
        enable = true;
        musicDirectory = "${config.xdg.userDirs.music}/Songs";
        playlistDirectory = "${config.xdg.userDirs.music}/Playlists";
      };
      services.mpdris2 = {
        enable = true;
        multimediaKeys = true;
      };
    };
}
