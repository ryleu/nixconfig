{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    # do not waste pixels
    general = {
      gaps_in = 0;
      gaps_out = 0;
      border_size = 1;
    };
    decoration = {
      rounding = 0;
      rounding_power = 0;
    };

    # clean up annoyances
    misc = {
      force_default_wallpaper = 1; # no anime girl
      disable_hyprland_logo = true;
      enable_anr_dialog = false; # no application not responding
    };

    # layout stuff
    # see https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    dwindle = {
      pseudotile = false;
      preserve_split = false;
      force_split = 2;
      split_width_multiplier = 1.5; # 16:9
    };

    # see https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    master = {
      new_status = "master";
    };

    # slow animations are for unixporn, not for real people
    animations = {
      enabled = true;

      bezier = [
        "specialWorkSwitch, 0.05, 0.5, 0.1, 1"
        "emphasizedAccel, 0.3, 0, 0.5, 0.15"
        "emphasizedDecel, 0.05, 0.5, 0.1, 1"
        "standard, 0.2, 0, 0, 1"
      ];

      animation = [
        "layersIn, 1, 1, emphasizedDecel, slide"
        "layersOut, 1, 1, emphasizedAccel, slide"
        "fadeLayers, 1, 1, standard"
        "windowsIn, 1, 1, emphasizedDecel"
        "windowsOut, 1, 1, emphasizedAccel"
        "windowsMove, 1, 1, standard"
        "workspaces, 1, 1, standard"
        "specialWorkspace, 0, 0, specialWorkSwitch, slidevert 15%"
        "fade, 1, 1, standard"
        "fadeDim, 1, 1, standard"
        "border, 1, 1, standard"
      ];
    };

  };
}
