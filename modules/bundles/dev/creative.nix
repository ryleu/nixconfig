# creative, office and utility apps
{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    let

      # force wayland on audacity
      audacity = pkgs.symlinkJoin {
        name = "audacity";
        paths = [ pkgs.audacity ];
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
        (python3.withPackages (
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
        krita # photos
        libreoffice # docs
        blender # 3d models
        libgourou # standalone adobe drm downloader
        picard # music metadata
        audacity # music editing

        # utilities
        ungoogled-chromium # good to have kicking around
        drawy # infinite whiteboard
        openscad # 3d modeling
        qbittorrent
        kicad # pcb viewing
        obsidian # for documentation and ideas

        # 3D print slicers
        prusa-slicer

        # games
        ace-of-penguins
        nethack
        rogue
      ];

      programs = {
        obs-studio = {
          enable = true;
          plugins = with pkgs.obs-studio-plugins; [
            wlrobs
            obs-vkcapture
            obs-pipewire-audio-capture
          ];
        };
      };
    };
}
