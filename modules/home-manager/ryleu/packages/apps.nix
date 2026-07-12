{ pkgs, inputs, ... }:
let
  master_pkgs = import inputs.master_pkgs {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  home.packages = with pkgs; [
    # comms
    signal-desktop

    # games
    master_pkgs.prismlauncher

    # 3D print slicers
    prusa-slicer
    orca-slicer
    bambu-studio

    # utilities
    qbittorrent
    hugin # panoramas for URC
    kicad # pcb viewing
    obsidian # for documentation and ideas

    # media
    picard # music metadata
    audacity # music editing
  ];

  programs = {
    vesktop.enable = true;
  };
}
