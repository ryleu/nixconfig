{ inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;

  unstable_pkgs = import inputs.unstable_pkgs {
    inherit system;
    config.allowUnfree = true;
  };

  # force wayland
  audacity = pkgs.symlinkJoin {
    name = "audacity";
    paths = [ unstable_pkgs.audacity ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/audacity \
        --set QT_QPA_PLATFORM wayland \
        --set AU_QT_QPA_PLATFORM wayland
    '';
  };
in
{
  home.packages = with pkgs; [
    # code
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

    # media
    imv # image viewer
    krita # photos
    libreoffice # docs
    blender # 3d models
    libgourou # standalone adobe drm downloader
    picard # music metadata
    audacity # music editing

    # utilities
    ungoogled-chromium # good to have kicking around
    wiremix # tui audio mixer
    gdu # tui disk usage
    drawy # infinite whiteboard
    openscad # 3d modeling
    qbittorrent
    kicad # pcb viewing
    obsidian # for documentation and ideas

    # 3D print slicers
    prusa-slicer
    bambu-studio

    # games
    ace-of-penguins
    nethack
    rogue
  ];

  programs = {
    mpv.enable = true;
    yazi = {
      enable = true;
      shellWrapperName = "y";
      plugins.duckdb = pkgs.yaziPlugins.duckdb;
    };

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-vkcapture
        obs-pipewire-audio-capture
      ];
    };

    kitty = {
      enable = true;
      settings = {
        notify_on_cmd_finish = "invisible";
      };
      shellIntegration = {
        enableZshIntegration = true;
      };
      keybindings = {
        "ctrl+shift+n" = "new_os_window_with_cwd";
      };
    };
  };
}
