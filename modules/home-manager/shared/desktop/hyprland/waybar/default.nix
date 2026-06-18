{ config, pkgs, ... }:
let
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  swaync-client = "${pkgs.swaynotificationcenter}/bin/swaync-client";

in
{
  stylix.targets.waybar.addCss = false;

  programs.waybar = {
    enable = true;
    systemd.enable = false;

    # patch to use new lua dispatcher syntax
    # https://github.com/Alexays/Waybar/issues/5008
    package = pkgs.waybar.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [ ./hyprland-lua-dispatch.patch ];
    });

    style =
      builtins.replaceStrings
        [ "\${font-family}" ]
        [
          "${builtins.concatStringsSep ", " (
            map (s: "\"${s}\"") config.fonts.fontconfig.defaultFonts.monospace
          )}"
        ]
        (builtins.readFile ./style.css);

    settings = {
      mainBar = {
        # General Waybar configuration
        position = "top";
        layer = "top";
        height = 16;
        spacing = 0;
        margin-top = 0;
        margin-right = 0;
        margin-left = 0;

        # Module placement
        modules-left = [
          "hyprland/workspaces"
          "hyprland/submap"
        ];

        modules-center = [ "clock" ];

        modules-right = [
          "pulseaudio"
          "backlight"
          "battery"
        ];

        # --------------------------------------------------
        # Modules configuration
        # --------------------------------------------------
        "hyprland/workspaces" = {
          separate-outputs = true;
        };

        "hyprland/submap" = {
          format = "{}";
          tooltip = false;
        };

        tray = {
          icon-size = 12;
          spacing = 7;
        };

        backlight = {
          # device = "acpi_video1";
          format = " 󰃠 {percent}%";

          # reverse scrolling because of natural scrolling hyprland
          on-scroll-down = "${brightnessctl} set 5%+";
          on-scroll-up = "${brightnessctl} set 5%-";

          smooth-scrolling-threshold = 1;
          tooltip = false;
          tooltip-format = "Brightness: {percent}%";
        };

        pulseaudio = {
          scroll-step = 1;

          format = "{icon} {volume}%";
          format-muted = "󰝟 {volume}%";
          format-bluetooth = "󰂰 {volume}%";
          format-bluetooth-muted = "󰂲 {volume}%";
          format-source = "󰍬 {volume}%";
          format-source-muted = "󰍭";

          format-icons = {
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };

          on-click = "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";

          # reverse scrolling because of natural scrolling hyprland
          on-scroll-down = "${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 1%+";
          on-scroll-up = "${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 1%-";

          tooltip = false;
          tooltip-format = "{desc} - {volume}%";
          max-volume = 100;
        };

        battery = {
          interval = 10;

          states = {
            good = 99;
            warning = 30;
            critical = 20;
          };

          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];

          format = " {icon} {capacity}%";
          format-critical = " {icon} {capacity}%";
          format-warning = " {icon} {capacity}%";
          format-full = " {icon} {capacity}%";
          format-charging = " 󰂅 {capacity}%";
          format-charging-warning = " 󰢝 {capacity}%";
          format-charging-critical = " 󰢜 {capacity}%";
          format-plugged = " 󰂅 {capacity}%";

          # was commented out in JSON:
          # format-alt = " 󱧥 {time}";

          tooltip = true;
          tooltip-format = " 󱧥 {time}";
        };

        clock = {
          format = "{:%H:%M}";

          # was commented out in JSON:
          # format-alt = "{:%m-%d-%Y}";

          tooltip = true;
          tooltip-format = "{:%Y-%m-%d}";

          # was commented out in JSON:
          # on-click-right = "gsimplecal";

          interval = 1;
        };

        mpris = {
          format = "{title} - {artist}";
          status-icons = {
            paused = "⏸";
          };
          tooltip = false;
        };

        "power-profiles-daemon" = {
          format = "{icon}";
          tooltip-format = "{profile}";
          tooltip = true;

          format-icons = {
            default = " 󰥔 ";
            performance = "  ";
            balanced = "  ";
            power-saver = "  ";
          };
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";

          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };

          return-type = "json";
          exec-if = "which ${swaync-client}";
          exec = "${swaync-client} -swb";
          on-click = "${swaync-client} -t -sw";
          on-click-right = "${swaync-client} -d -sw";
          escape = true;
        };

        "custom/submapKeybinds" = {
          tooltip = false;
          format = "bindings";
        };
      };
    };
  };

  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar";
      PartOf = [ "hyprland-session.target" ];
      After = [ "hyprland-session.target" ];
    };

    Service = {
      ExecStart = "${config.programs.waybar.package}/bin/waybar";
      Restart = "on-failure";
      RestartSec = 1;
    };

    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
  };

  home.packages = with pkgs; [
    pkgs.brightnessctl

    # not enabled but still defined in the config
    playerctl
    power-profiles-daemon
  ];
}
