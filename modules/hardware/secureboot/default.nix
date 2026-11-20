{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  pkiBundle = "/var/lib/sbctl";
  secrets = ../../nixos/agenix/ryleu;

  # sbctl runs in sandbox, needs actual files instead of symlink to /run/agenix
  key = file: path: {
    inherit file;
    path = "${pkiBundle}/keys/${path}";
    symlink = false;
    mode = "400";
    owner = "root";
    group = "root";
  };

  copy = source: {
    "C+".argument = "${source}";
  };
in
{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  # lanzaboote instead of systemd-boot for secureboot signing
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    inherit pkiBundle;
  };

  environment.systemPackages = [ pkgs.sbctl ];

  # make sure sbctl can see the keys
  age.secrets = {
    secureboot-pk-key = key (secrets + "/secureboot-pk-key.age") "PK/PK.key";
    secureboot-kek-key = key (secrets + "/secureboot-kek-key.age") "KEK/KEK.key";
    secureboot-db-key = key (secrets + "/secureboot-db-key.age") "db/db.key";
  };

  systemd.tmpfiles.settings."10-secureboot" = {
    "${pkiBundle}/GUID" = copy ./GUID;
    "${pkiBundle}/keys/PK/PK.pem" = copy ./PK.pem;
    "${pkiBundle}/keys/KEK/KEK.pem" = copy ./KEK.pem;
    "${pkiBundle}/keys/db/db.pem" = copy ./db.pem;
  };
}
