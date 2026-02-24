{
  config,
  lib,
  pkgs,
  ...
}:
let
  hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
  loginctl = "${pkgs.systemd}/bin/loginctl";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
in
{
  # This file handles power management and auto locking

  services = {
    hypridle = {
      enable = true;

      settings = {
        general = {
          lock_cmd = "pidof hyprlock || ${hyprlock} --immediate";
          before_sleep_cmd = "${loginctl} lock-session";
          after_sleep_cmd = "${hyprctl} dispatch dpms on";
        };

        listener = lib.mkDefault [
        ];
      };
    }; # end hypridle
  }; # end services

  programs = {
    hyprlock = {
      enable = true;

      settings = {
        general = {
          disable_loading_bar = true;
          grace = 60;
          hide_cursor = true;
          no_fade_in = true;
          immediate_render = true;
        };

        background = [
          {
            color = "rgb(000000)";
          }
        ];

        input-field = [
          {
            size = "50%, 50%";
            position = "0, 0";
            monitor = "";

            dots_center = true;
            dots_text_format = "*";
            dots_size = 0.2;
            dots_spacing = 0.2;

            font_color = "rgb(7F7F7F)";
            inner_color = "rgb(000000)";
            outer_color = "rgb(000000)";
            placeholder_text = "";
            rounding = 0;
            font_family = builtins.head config.fonts.fontconfig.defaultFonts.monospace;

            fade_on_empty = true; # oled
            fade_timeout = 5 * 60 * 1000; # 5 mins

            numlock_color = "rgb(000000)";
            capslock_color = "rgb(7F007F)";
            bothlock_color = "rgb(7F007F)";

            fail_color = "rgb(7F0000)";
            fail_text = "";

            check_color = "rgb(007F7F)";

            halign = "center";
            valign = "center";
          }
        ];
      };
    }; # end hyprlock
  }; # end programs
}
