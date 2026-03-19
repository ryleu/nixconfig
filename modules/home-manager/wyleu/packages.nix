{ inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;

  master_pkgs = import inputs.master_pkgs {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  home.packages = with pkgs; [
    # code editor
    master_pkgs.code-cursor

    # utilities
    dbeaver-bin

    # cli
    glab
    master_pkgs.claude-code
    docker-buildx # better docker builder

    # apps
    inputs.claude-desktop.packages.${system}.claude-desktop-with-fhs
  ];
}
