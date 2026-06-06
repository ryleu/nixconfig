let
  users = import ./authorized_keys.nix;

  ethernet-port = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOc5p4P2Uq8vDDxQL7ssgoPFArI+c2B8ZQdXJTh+priX root@ethernet-port";

  # wyleu is only on ethernet-port
  systems = [
    ethernet-port
  ];
in
{
  "id_ed25519-key.age".publicKeys = users ++ systems;
}
