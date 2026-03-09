let
  users = import ./authorized_keys.nix;

  rectangle = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN2CjaY+uiOHdCEpPCdlJ+2fDtm8vdu+Jvbyo9Q+abwB root@rectangle";
  barely-better = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAWotWG7ZQEFVI5qmnsK/VAaqEqaJlhV60NYz4iJACJq root@barely-better";
  ethernet-port = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOc5p4P2Uq8vDDxQL7ssgoPFArI+c2B8ZQdXJTh+priX root@ethernet-port";

  systems = [
    rectangle
    barely-better
    ethernet-port
  ];
in
{
  "id_ed25519-key.age".publicKeys = users ++ systems;
}
