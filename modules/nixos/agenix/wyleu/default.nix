{ inputs, ... }:
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  age.secrets = {
    id_ed25519-key-wyleu = {
      file = ./id_ed25519-key.age;
      path = "/home/wyleu/.ssh/id_ed25519";
      mode = "600";
      owner = "wyleu";
      group = "users";
    };
  };
}
