{ pkgs, ... }:
let
  # map lua placeholders to store paths
  paths = {
    kitty = "${pkgs.kitty}/bin/kitty";
    rofi = "${pkgs.rofi}/bin/rofi";
    hyprshot = "${pkgs.hyprshot}/bin/hyprshot";
    playerctl = "${pkgs.playerctl}/bin/playerctl";
    brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
    hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
    file_manager = "${pkgs.kitty}/bin/kitty --class yazi ${pkgs.yazi}/bin/yazi";
    hyprmon = "${pkgs.hyprmon}/bin/hyprmon";
    wpctl = "${pkgs.wireplumber}/bin/wpctl";
    hyprctl = "${pkgs.hyprland}/bin/hyprctl";
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
    ./portals.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    configType = "lua";

    extraConfig = substitute (builtins.readFile ./hyprland.lua);
  };

  programs.rofi.enable = true;

  services.hyprpolkitagent.enable = true;
}
