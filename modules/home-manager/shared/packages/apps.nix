{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
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
      mpv # videos
      spotify # music
      calibre # book metadata
      krita # photos
      libreoffice # docs

      # utilities
      pavucontrol
      bottles
      qdirstat
      logseq
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
