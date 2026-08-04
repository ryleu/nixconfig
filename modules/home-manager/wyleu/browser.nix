{ pkgs, ... }:
let
  certDir = import ../../lib/dod-certs.nix { inherit pkgs; };

  certList = map (name: "${certDir}/${name}") (builtins.attrNames (builtins.readDir certDir));
in
{
  programs.zen-browser = {
    policies = {
      SecurityDevices.CAC-Device = "${pkgs.opensc}/lib/opensc-pkcs11.so";
      Certificates.Install = certList;
    };

    profiles.default = {
      extensions.packages = with pkgs.firefox-addons; [
        bitwarden
      ];
    };
  };
}
