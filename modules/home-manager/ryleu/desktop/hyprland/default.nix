{
  pkgs,
  ...
}:
{
  imports = [
    ./binds.nix
    ./lock.nix
    ./waybar
    ./look-and-feel.nix
    ./devices.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    settings = {
      # the default for monitors to be automatic
      monitor = pkgs.lib.mkDefault [
        ", preferred, auto, 1"
      ];

      # makes some electron apps work a bit better
      env = [
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
      ];

      # see https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      # see https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules
      windowrule = [
        # ignore maximize requests from apps
        "suppressevent maximize, class:.*"

        # fix some dragging issues with xwayland
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
    }; # end settings
  }; # end wayland.windowManager.hyprland
}
