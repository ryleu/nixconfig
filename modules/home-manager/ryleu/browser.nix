{
  pkgs,
  ...
}:
{
  programs.zen-browser = {
    profiles.default = {
      extensions.packages = with pkgs.firefox-addons; [
        bitwarden
        tasks-for-canvas
        sponsorblock
        youtube-recommended-videos
        return-youtube-dislikes
      ];
    };
  };
}
