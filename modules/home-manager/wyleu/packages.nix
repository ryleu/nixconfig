{ inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;

  master_pkgs = import inputs.master_pkgs {
    inherit system;
    config.allowUnfree = true;
  };

  # claude-desktop
  claudeDesktopSrc = inputs.claude-desktop;
  patchy-cnb = pkgs.callPackage "${claudeDesktopSrc}/pkgs/patchy-cnb.nix" { };
  claude-desktop = pkgs.callPackage "${claudeDesktopSrc}/pkgs/claude-desktop.nix" {
    inherit patchy-cnb;
    nodePackages = { inherit (pkgs) asar; };
  };
  claude-desktop-with-fhs = pkgs.buildFHSEnv {
    name = "claude-desktop";
    targetPkgs =
      pkgs: with pkgs; [
        docker
        glibc
        openssl
        nodejs
        uv
      ];
    runScript = "${claude-desktop}/bin/claude-desktop";
    extraInstallCommands = ''
      mkdir -p $out/share/applications
      cp ${claude-desktop}/share/applications/claude.desktop $out/share/applications/
      mkdir -p $out/share/icons
      cp -r ${claude-desktop}/share/icons/* $out/share/icons/
    '';
  };
in
{
  home.packages = with pkgs; [
    # utilities
    dbeaver-bin

    # cli
    glab
    master_pkgs.claude-code
    docker-buildx # better docker builder
    master_pkgs.liteparse

    # apps
    claude-desktop-with-fhs
  ];
}
