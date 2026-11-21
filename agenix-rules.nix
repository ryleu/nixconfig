# secret decryption rules
let
  # users & keys
  ryleu = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPn/d2gkRPiBxJbFC5PHdusFRH2hA0MpszwLl5xDIppb riley@ryleu.me"
  ];
  wyleu = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID3ETWWGQPgH2cNSFvdyo6/kA9Xni/cebIEz8mXqqzYD riley.mclain@watts.ai"
  ];

  # machines & host keys
  stela = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOc5p4P2Uq8vDDxQL7ssgoPFArI+c2B8ZQdXJTh+priX root@stela";

  # only decrypt all keys on stela
  trusted = [ stela ];
in
{
  "secrets/ryleu-attic-token.age".publicKeys = ryleu ++ trusted;
  "secrets/ryleu-cosign-key.age".publicKeys = ryleu ++ trusted;
  "secrets/ryleu-github-key.age".publicKeys = ryleu ++ trusted;
  "secrets/ryleu-id_ed25519-key.age".publicKeys = ryleu ++ trusted;
  "secrets/ryleu-monument-key.age".publicKeys = ryleu ++ trusted;
  "secrets/ryleu-proxy-key.age".publicKeys = ryleu ++ trusted;
  "secrets/ryleu-redoak-key.age".publicKeys = ryleu ++ trusted;
  "secrets/ryleu-ripi-key.age".publicKeys = ryleu ++ trusted;
  "secrets/ryleu-syncthing-cert-stela.age".publicKeys = ryleu ++ trusted;
  "secrets/ryleu-syncthing-key-stela.age".publicKeys = ryleu ++ trusted;
  "secrets/ryleu-syncthing-password.age".publicKeys = ryleu ++ trusted;
  "secrets/wyleu-id_ed25519-key.age".publicKeys = wyleu ++ trusted;
}
