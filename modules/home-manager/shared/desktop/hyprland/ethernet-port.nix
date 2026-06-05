{ osConfig, ... }:
if osConfig.networking.hostName == "ethernet-port" then
  {
    wayland.windowManager.hyprland.extraConfig = builtins.readFile ./ethernet-port.lua;
  }
else
  { }
