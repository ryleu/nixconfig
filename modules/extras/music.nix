{ config, ... }:
{
  flake.modules.homeManager.music =
    { pkgs, ... }:
    {
      programs.spotify-player.enable = true;
      xdg.desktopEntries.spotify-player = config.helpers.mkTuiLauncher pkgs "Spotify" pkgs.spotify-player;
    };
}
