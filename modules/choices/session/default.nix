# session manager choice
{
  settings.session =
    { lib, ... }:
    {
      options = {
        kind = lib.mkOption {
          type = lib.types.enum [
            "greeter"
            "game"
            "none"
          ];
          description = ''
            Session manager type.

            - `greeter`: via greetd
            - `game`: autologin to Gamescope + Steam Big Picture
            - `none`: no session manager
          '';
        };
        user = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "User for autologin sessions. Defaults to the machine's only user.";
        };
      };
    };
  variants.session = [ "kind" ];
}
