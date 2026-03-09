{ inputs, pkgs, ... }:
let
  master_pkgs = import inputs.master_pkgs {
    system = pkgs.stdenv.hostPlatform.system;
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
  ];
}
