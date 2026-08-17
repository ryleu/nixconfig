{ inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;

  unstable_pkgs = import inputs.unstable_pkgs {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  home.packages = with unstable_pkgs; [
    typst
    typstyle
    typst-live
  ];

  programs.zathura.enable = true;
}
