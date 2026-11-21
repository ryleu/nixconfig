# open in...
{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        imv # image viewer
      ];

      programs = {
        mpv.enable = true;
        yazi = {
          enable = true;
          shellWrapperName = "y";
          plugins.duckdb = pkgs.yaziPlugins.duckdb;
        };
        zathura.enable = true;
      };
    };
}
