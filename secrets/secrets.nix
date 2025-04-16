let
  users = import ./authorized_keys;

  rectangle = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRbbUTDpqCJcomV4S3K63TbF9aV8MpxVQ0fjot98SDs root@rectangle";

  systems = [ rectangle ];
in
{
  "ripi-key.age".publicKeys = users ++ systems;
}
