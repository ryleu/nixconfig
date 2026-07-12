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
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
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
          {
            # dim the screen after 2 minutes
            timeout = 120;
            on-timeout = "${brightnessctl} --save set 10%";
            on-resume = "${brightnessctl} --restore";
          }
          {
            # lock after 3 minutes
            timeout = 180;
            on-timeout = "${loginctl} lock-session";
          }
          {
            # turn displays off after 5 minutes
            timeout = 300;
            on-timeout = "${hyprctl} dispatch dpms off";
            on-resume = "${hyprctl} dispatch dpms on";
          }
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

  # inhibit idle (dim/lock/dpms) while audio is playing
  systemd.user.services.sway-audio-idle-inhibit = {
    Unit = {
      Description = "Inhibit idle while audio is playing";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
