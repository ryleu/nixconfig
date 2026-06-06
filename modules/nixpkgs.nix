{ inputs, ... }:
{
  flake.modules.nixos.base = {
    nixpkgs.overlays = [
      inputs.firefox-addons.overlays.default
      (final: _prev: {
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit (final.stdenv.hostPlatform) system;
          config.allowUnfree = true;
        };
      })
    ];
    nixpkgs.config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        # for logseq
        "electron-39.8.10"
      ];
    };
  };
}
