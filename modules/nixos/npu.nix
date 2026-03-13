{
  pkgs,
  inputs,
  ...
}:
let
  master_pkgs = import inputs.master_pkgs {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  hardware.firmware = [
      master_pkgs.linux-firmware
  ];

  users.users.wyleu.extraGroups = [
    "amdxdna"
  ];

  users.groups.amdxdna = {};

  security.pam.loginLimits = [
    { domain = "@amdxdna"; type = "soft"; item = "memlock"; value = "unlimited"; }
    { domain = "@amdxdna"; type = "hard"; item = "memlock"; value = "unlimited"; }
  ];
}
