{ lib, ... }:
{
  wayland.windowManager.hyprland.settings.monitor = lib.mkForce [
    "eDP-1, 2880x1800, 0x1080, 1.5"
    "desc:Dell Inc. DELL P2722H FRL6293, 1920x1080, 0x0, 1"
    "desc:Dell Inc. DELL P2722H 6QL6293, 1920x1080, 1920x0, 1, transform, 3"
  ];
}
