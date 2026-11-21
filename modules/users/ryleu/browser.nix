{
  flake.modules.homeManager.ryleu-browser =
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
            extensions.packages = with pkgs.firefox-addons; [
              proton-pass
              proton-vpn
            ];
          };
        };
      };
    };
}
