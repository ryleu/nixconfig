{ config, ... }:
{
  home.sessionVariables.HYPRCURSOR_SIZE = config.home.pointerCursor.size;

  home.pointerCursor = {
    hyprcursor = {
      enable = true;
      size = config.home.pointerCursor.size;
    };
    dotIcons.enable = true;
  };
}
