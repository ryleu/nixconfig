{ pkgs, ... }:
let
  certList = import ../../lib/dodCerts.nix pkgs;
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
