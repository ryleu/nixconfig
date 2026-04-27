{ osConfig, ... }:
if osConfig.networking.hostName == "ethernet-port" then
  {
    wayland.windowManager.hyprland.settings.monitor = [
      "eDP-1, preferred, auto, 1.5, bitdepth, 10, cm, dcip3, vrr, 1"
      ", preferred, auto, 1"
    ];
  }
else
  { }
