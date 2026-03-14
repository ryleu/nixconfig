{ pkgs, ... }:
let
  # program shortcuts
  wpctl = "${pkgs.hyprshot}/bin/hyprshot";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  rofi = "${pkgs.rofi}/bin/rofi";
  hyprshot = "${pkgs.hyprshot}/bin/hyprshot";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
  kitty = "${pkgs.kitty}/bin/kitty";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  file-manager = "${pkgs.nautilus}/bin/nautilus";
  hyprmon = "${pkgs.hyprmon}/bin/hyprmon";

  # custom scripts
  toggle-touchpad-disable = "${pkgs.writeShellScriptBin "toggle" ''
    if ${hyprctl} getoption input:touchpad:disable_while_typing | grep -q "int: 1"; then
      ${hyprctl} keyword input:touchpad:disable_while_typing false
    else
      ${hyprctl} keyword input:touchpad:disable_while_typing true
    fi
  ''}/bin/toggle";

  # nix shortcuts
  mod = a: b: a - (b * (a / b));
  genKeybinds =
    n: # n will go 1 -> 10
    if n > 10 then
      [ ]
    else
      [
        # now for the actual keybinds
        # Switch workspaces with mainMod + [0-9]
        "SUPER, ${toString (mod n 10)}, workspace, ${toString n}"
        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "SUPER SHIFT, ${toString (mod n 10)}, movetoworkspacesilent, ${toString n}"
        # The same, but add ALT for +10
        "SUPER ALT, ${toString (mod n 10)}, workspace, ${toString (n + 10)}"
        "SUPER ALT SHIFT, ${toString (mod n 10)}, movetoworkspacesilent, ${toString (n + 10)}"
      ]
      ++ genKeybinds (n + 1); # and finally the recursion where we concat the next number up
in
{
  wayland.windowManager.hyprland.settings = {
    # See https://wiki.hyprland.org/Configuring/Binds/ for more
    bind = [
      "SUPER, RETURN, exec, ${kitty}"
      "SUPER, C, killactive,"
      "SUPER, S, toggleSpecialWorkspace, magic"
      "SUPER SHIFT, S, movetoworkspace, special:magic"
      "SUPER SHIFT, ESCAPE, exit,"
      "SUPER, E, exec, ${file-manager}"
      "SUPER, V, togglefloating,"
      "SUPER, F, fullscreen, 1"
      "SUPER SHIFT, F, fullscreen, 0"
      "SUPER, ESCAPE, exec, ${hyprlock} --immediate"
      "SUPER, T, exec, ${toggle-touchpad-disable}"

      # Move focus with mainMod + H J K L
      "SUPER, H, movefocus, l"
      "SUPER, J, movefocus, d"
      "SUPER, K, movefocus, u"
      "SUPER, L, movefocus, r"

      # Scroll through existing workspaces with mainMod + scroll
      "SUPER, mouse_down, workspace, e+1"
      "SUPER, mouse_up, workspace, e-1"

      # app runner
      "SUPER, R, exec, ${rofi} -show drun"
      "SUPER SHIFT, 201, exec, ${rofi} -show drun"

      # monitor control
      "SUPER, M, exec, [float] ${kitty} -o confirm_os_window_close=0 --name Hyprmon ${hyprmon}"

      # screenshot
      "     , PRINT, exec, ${hyprshot} -z -m output -m active --clipboard-only"
      "SHIFT, PRINT, exec, ${hyprshot} -m region --clipboard-only"
      "CTRL , PRINT, exec, ${hyprshot} -z -m window --clipboard-only"
    ]
    ++ genKeybinds 1; # call the function to generate keybinds for workspaces 1 -> 10

    bindm = [
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, resizewindow"
    ];

    # Laptop multimedia keys for volume and LCD brightness
    bindel = [
      ",XF86AudioRaiseVolume, exec, ${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, exec, ${brightnessctl} s 10%+"
      ",XF86MonBrightnessDown, exec, ${brightnessctl} s 10%-"
    ];

    bindl = [
      ",XF86AudioNext, exec, ${playerctl} next"
      ",XF86AudioPause, exec, ${playerctl} play-pause"
      ",XF86AudioPlay, exec, ${playerctl} play-pause"
      ",XF86AudioPrev, exec, ${playerctl} previous"
    ];

    # i hate whoever thought this was a good idea
    misc.middle_click_paste = false;

    # https://wiki.hypr.land/Configuring/Gestures/
    gesture = [
      "3, horizontal, workspace"
    ];
  };

  programs.rofi = {
    enable = true;
    theme = "gruvbox-dark-soft";
  };
}
