# networking system choice
{
  settings.network =
    { lib, ... }:
    {
      options = {
        stack = lib.mkOption {
          type = lib.types.enum [
            "networkd"
            "networkmanager"
          ];
          default = "networkd";
          description = ''
            Network management stack.

            - `networkd`: default, modern setup
            - `networkmanager`: for compat with Steam Big Picture
          '';
        };
        wifi = lib.mkOption {
          type = lib.types.enum [
            "none"
            "iwd"
          ];
          default = "none";
          description = ''
            Wi-Fi management program.

            - `none`: default, no Wi-Fi
            - `iwd`: use iwd to manage Wi-Fi
          '';
        };
      };
    };
  variants.network = [
    "stack"
    "wifi"
  ];
}
