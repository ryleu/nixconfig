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
    master_pkgs.vesktop
    master_pkgs.teamspeak6-client

    # games
    master_pkgs.prismlauncher

    # 3D print slicers
    prusa-slicer
    orca-slicer
    bambu-studio

    # utilities
    qbittorrent
    hugin # panoramas for URC

    # media
    picard # music metadata
    audacity # music editing
  ];
}
