{
  flake.modules.homeManager.desktop =
    { config, ... }:
    {
      programs.rofi = {
        enable = true;
        theme.window = {
          border = config.lib.formats.rasi.mkLiteral "1px";
          border-color = config.lib.formats.rasi.mkLiteral "@blue";
        };
      };
    };
}
