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
    teamspeak6-client

    # games
    master_pkgs.prismlauncher
    alvr

    # 3D print slicers
    prusa-slicer
    orca-slicer
    bambu-studio

    # utilities
    qbittorrent
    hugin # panoramas for URC
    kicad # pcb viewing

    # media
    picard # music metadata
    audacity # music editing
  ];

  programs = {
    vesktop.enable = true;
  };
}
