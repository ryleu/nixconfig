{ inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;

  master_pkgs = import inputs.master_pkgs {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  home.packages = with master_pkgs; [
    typst
    typstyle
    typst-live
  ];

  programs.zathura.enable = true;
}
