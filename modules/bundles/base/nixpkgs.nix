# what the system package set allows and adds
{ inputs, ... }:
{
  flake.modules.nixos.base = {
    nixpkgs = {
      overlays = [
        inputs.firefox-addons.overlays.default
      ];
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "electron-39.8.10"
        ];
      };
    };
  };
}
