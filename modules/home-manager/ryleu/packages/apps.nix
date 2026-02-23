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
      qdirstat
      calibre
      signal-desktop
      qbittorrent
      krita
      vlc
      spotify
      prismlauncher
      master_pkgs.zed-editor-fhs
      vesktop
      vscode-fhs
      (python312.withPackages (py: [
        py.bpython
	ncurses
        py.numpy
        py.jupyter
        py.uv
        py.pip
        py.matplotlib
      ]))
      hugin
      qgis
      logseq
      gabutdm
      prusa-slicer
      orca-slicer
      bambu-studio
      pavucontrol
      bottles
      picard
      master_pkgs.stoat-desktop
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
