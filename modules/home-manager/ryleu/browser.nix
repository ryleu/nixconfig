{
  pkgs,
  ...
}:
{
  stylix.targets.zen-browser.profileNames = [ "ginisight" ];

  programs.zen-browser = {
    profiles = {
      default = {
        id = 0;

        extensions.packages = with pkgs.firefox-addons; [
          bitwarden
          tasks-for-canvas
          sponsorblock
          youtube-recommended-videos
          return-youtube-dislikes
        ];
      };

      ginisight = {
        id = 1;

        spacesForce = true;
        spaces = {
          "Business" = {
            id = "f2056243-dd4e-4a0c-aec0-dae334ca31b2";
            position = 1000;
            icon = "chrome://browser/skin/zen-icons/selectable/briefcase.svg";
          };
          "Development" = {
            id = "5a1aaaf0-cc7f-47f9-a773-3c223205e262";
            position = 2000;
            icon = "chrome://browser/skin/zen-icons/selectable/code.svg";
          };
        };

        mods = [
          "1b88a6d1-d931-45e8-b6c3-bfdca2c7e9d6" # Remove Tab X
          "c01d3e22-1cee-45c1-a25e-53c0f180eea8" # Ghost Tabs
          "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No Sidebar Scrollbar
        ];

        extensions.packages = with pkgs.firefox-addons; [
          ublock-origin
          proton-pass
          proton-vpn
        ];
      };
    };
  };
}
