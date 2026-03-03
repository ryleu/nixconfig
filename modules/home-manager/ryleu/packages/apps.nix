{ pkgs, inputs, ... }:
let
  master_pkgs = import inputs.master_pkgs {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  home = {
    packages = with pkgs; [
      # communication
      signal-desktop
      master_pkgs.stoat-desktop
      vesktop

      # code
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

      # media
      vlc # videos
      spotify # music
      picard # music metadata
      audacity # music editing
      calibre # book metadata
      krita # photos
      libreoffice # docs

      # 3D print slicers
      prusa-slicer
      orca-slicer
      bambu-studio

      # utilities
      pavucontrol
      bottles
      qdirstat
      qbittorrent
      hugin # panoramas for URC
      logseq # D&D notes

      # games
      prismlauncher
    ];
  };

  programs = {
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
    };
  };
}
