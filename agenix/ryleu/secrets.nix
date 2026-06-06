let
  users = import ./authorized_keys.nix;

  rectangle = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN2CjaY+uiOHdCEpPCdlJ+2fDtm8vdu+Jvbyo9Q+abwB root@rectangle";
  ethernet-port = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOc5p4P2Uq8vDDxQL7ssgoPFArI+c2B8ZQdXJTh+priX root@ethernet-port";

  systems = [
    rectangle
    ethernet-port
  ];
in
{
  "ripi-key.age".publicKeys = users ++ systems;
  "github-key.age".publicKeys = users ++ systems;
  "id_ed25519-key.age".publicKeys = users ++ systems;
  "redoak-key.age".publicKeys = users ++ systems;
  "proxy-key.age".publicKeys = users ++ systems;
  "monument-key.age".publicKeys = users ++ systems;
  "cosign-key.age".publicKeys = users ++ systems;
  "syncthing-password.age".publicKeys = users ++ systems;

  # ethernet-port specific
  "syncthing-cert-ethernet-port.age".publicKeys = users ++ [ ethernet-port ];
  "syncthing-key-ethernet-port.age".publicKeys = users ++ [ ethernet-port ];
}
