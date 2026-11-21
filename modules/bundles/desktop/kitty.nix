{
  flake.modules.homeManager.desktop = {
    programs.kitty = {
      enable = true;
      settings = {
        notify_on_cmd_finish = "invisible";
      };
      shellIntegration = {
        enableZshIntegration = true;
      };
      keybindings = {
        "ctrl+shift+n" = "new_os_window_with_cwd";
      };
    };
  };
}
