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
          lock_cmd = "pidof hyprlock || ${hyprlock} --grace 0";
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
          hide_cursor = true;
          immediate_render = true;
        };
      };
    }; # end hyprlock
  }; # end programs
}
