{
  config,
  pkgs,
  ...
}:
let
  # map lua placeholders to store paths
  paths = {
    kitty = "${pkgs.kitty}/bin/kitty";
    rofi = "${pkgs.rofi}/bin/rofi";
    hyprshot = "${pkgs.hyprshot}/bin/hyprshot";
    playerctl = "${pkgs.playerctl}/bin/playerctl";
    brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
    hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
    file_manager = "${pkgs.nautilus}/bin/nautilus";
    hyprmon = "${pkgs.hyprmon}/bin/hyprmon";
    wpctl = "${pkgs.wireplumber}/bin/wpctl";
    hyprctl = "${pkgs.hyprland}/bin/hyprctl";
    cursor_name = "'${config.home.pointerCursor.name}'";
    cursor_size = toString config.home.pointerCursor.size;
    toggle_touchpad = "${pkgs.writeShellScriptBin "toggle" ''
      if ${pkgs.hyprland}/bin/hyprctl getoption input:touchpad:disable_while_typing | grep -q "int: 1"; then
        ${pkgs.hyprland}/bin/hyprctl keyword input:touchpad:disable_while_typing false
      else
        ${pkgs.hyprland}/bin/hyprctl keyword input:touchpad:disable_while_typing true
      fi
    ''}/bin/toggle";
  };

  substitute =
    template:
    builtins.replaceStrings (map (n: "@${n}@") (
      builtins.attrNames paths
    )) (builtins.attrValues paths) template;
in
{
  imports = [
    ./lock.nix
    ./waybar
    ./ethernet-port.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    configType = "lua";

    extraConfig = substitute (builtins.readFile ./hyprland.lua);
  };

  programs.rofi = {
    enable = true;
    theme = "gruvbox-dark-soft";
  };

  services.hyprpolkitagent.enable = true;
}
