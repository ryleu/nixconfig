let
  users = import ./authorized_keys.nix;

  rectangle = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN2CjaY+uiOHdCEpPCdlJ+2fDtm8vdu+Jvbyo9Q+abwB root@rectangle";
  barely-better = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAWotWG7ZQEFVI5qmnsK/VAaqEqaJlhV60NYz4iJACJq root@barely-better";

  systems = [
    rectangle
    barely-better
  ];
in
{
  "ripi-key.age".publicKeys = users ++ systems;
  "github-key.age".publicKeys = users ++ systems;
  "voron-key.age".publicKeys = users ++ systems;
  "id_ed25519-key.age".publicKeys = users ++ systems;
  "redoak-key.age".publicKeys = users ++ systems;
  "proxy-key.age".publicKeys = users ++ systems;
  "monument-key.age".publicKeys = users ++ systems;
  "clucky-key.age".publicKeys = users ++ systems;
  "remotebuild-key.age".publicKeys = users ++ systems;
  "cosign-key.age".publicKeys = users ++ systems;
}
