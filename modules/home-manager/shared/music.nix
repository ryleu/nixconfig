{ config, ... }:
{
  services = {
    mpd = {
      enable = true;
      musicDirectory = "${config.xdg.userDirs.music}/Songs";
      playlistDirectory = "${config.xdg.userDirs.music}/Playlists";
    };

    mpdris2 = {
      enable = true;
      multimediaKeys = true;
    };
  };
}
