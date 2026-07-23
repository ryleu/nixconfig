{
  pkgs,
  ...
}:
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
    # utilities
    ungoogled-chromium # good to have kicking around
    wiremix # tui audio mixer
    gdu # tui disk usage
    drawy # infinite whiteboard
  ];

  programs = {
    mpv.enable = true;
    yazi = {
      enable = true;
      shellWrapperName = "y";
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
