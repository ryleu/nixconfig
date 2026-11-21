# like SteamOS's game mode
{ inputs, ... }:
{
  flake.modules.nixos.session-game =
    { config, ... }:
    let
      users = builtins.attrNames config.home-manager.users;
      chosen = config.parts.session.user;
      user =
        if chosen != null then
          chosen
        # grab the user if there is only one
        else if builtins.length users == 1 then
          builtins.head users
        else
          throw "session: set the user setting, this machine has more than one user";
    in
    {
      imports = [ inputs.jovian.nixosModules.default ];

      jovian.steam = {
        enable = true;
        autoStart = true;
        inherit user;
        desktopSession = "hyprland";
      };
    };
}
