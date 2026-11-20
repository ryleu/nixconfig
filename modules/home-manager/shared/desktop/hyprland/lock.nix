{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  # the lock screen is themed to look like tuigreet
  colors = config.lib.stylix.colors;
  bg = "rgb(${colors.base00})";
  fg = "rgb(${colors.base05})";
  red = "rgb(${colors.base08})";

  font = "FiraCode Nerd Font Mono";
  fontSize = 19;
  # 16x32 grid like tuigreet and plymouth
  cellW = 16;
  cellH = 2 * cellW;

  # the border goes through the middle of the outer cells
  boxW = 79 * cellW;
  boxH = 4 * cellH;
  textLeft = -boxW / 2 + 1.5 * cellW;

  round = x: builtins.floor (x + 0.5);
  at = x: y: "${toString (round x)}, ${toString (round y)}";

  # anchor to the middle of the display
  text =
    {
      string,
      row,
      color ? fg,
    }:
    {
      text = string;
      inherit color;
      font_family = font;
      font_size = fontSize;
      halign = "center";
      valign = "center";
      position = at (textLeft + (builtins.stringLength string) * cellW / 2) (-row * cellH);
      zindex = 2;
    };

  title = "Locked ${osConfig.networking.hostName}";
  prompt = "Password:";
  fieldW = 60 * cellW;

  hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
  loginctl = "${pkgs.systemd}/bin/loginctl";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
in
{
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

        # disable animations / transitions to make it feel like a terminal
        animations.enabled = false;

        background = lib.mkForce [ { color = bg; } ];

        shape = [
          # the box
          {
            size = at boxW boxH;
            position = at 0 0;
            halign = "center";
            valign = "center";
            color = bg;
            rounding = 0;
            border_size = 2;
            border_color = fg;
            zindex = 0;
          }
          # a gap in the top border for the title
          {
            size = at ((builtins.stringLength title + 2) * cellW) cellH;
            position = at (textLeft + (builtins.stringLength title) * cellW / 2) (boxH / 2);
            halign = "center";
            valign = "center";
            color = bg;
            rounding = 0;
            border_size = 0;
            zindex = 1;
          }
        ];

        label = [
          (text {
            string = title;
            row = -2;
          })
          (text {
            string = prompt;
            row = 0;
          })
          # pam and fingerprint errors under the box
          {
            text = "$FAIL";
            color = red;
            font_family = font;
            font_size = fontSize;
            halign = "center";
            valign = "center";
            position = at 0 (-boxH / 2 - 2 * cellH);
          }
          # like tuigreet --time
          {
            text = ''cmd[update:5000] date +"%a, %d %b %Y - %H:%M"'';
            color = fg;
            font_family = font;
            font_size = fontSize;
            halign = "center";
            valign = "top";
            position = at 0 (-cellH);
          }
          # offset a little for rounded corners
          {
            text = "$FPRINTPROMPT";
            color = fg;
            font_family = font;
            font_size = fontSize;
            halign = "left";
            valign = "bottom";
            position = at (3 * cellW) cellH;
          }
        ];

        # only show asterisks in the field
        input-field = lib.mkForce [
          {
            size = at fieldW cellH;
            position = at (textLeft + (builtins.stringLength prompt + 1) * cellW + fieldW / 2) 0;
            halign = "center";
            valign = "center";
            rounding = 0;
            outline_thickness = 0;
            inner_color = "rgba(00000000)";
            outer_color = "rgba(00000000)";
            check_color = "rgba(00000000)";
            fail_color = "rgba(00000000)";
            font_color = fg;
            font_family = font;
            dots_text_format = "*";
            dots_center = false;
            dots_size = 0.61;
            dots_spacing = 0.0;
            fade_on_empty = false;
            placeholder_text = "";
            fail_text = "";
            zindex = 2;
          }
        ];
      };
    }; # end hyprlock
  }; # end programs

  # don't rely on stylix for theming
  stylix.targets.hyprlock.enable = false;

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
