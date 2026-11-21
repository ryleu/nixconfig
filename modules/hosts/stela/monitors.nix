# load extra hyprland monitors config
{
  hosts.stela.modules = [
    {
      home-manager.sharedModules = [
        { wayland.windowManager.hyprland.extraConfig = builtins.readFile ./monitors.lua; }
      ];
    }
  ];
}
