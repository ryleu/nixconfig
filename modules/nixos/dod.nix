{ pkgs, ... }:

{
  security.pki.certificateFiles = import ../lib/dodCerts.nix pkgs;
}
