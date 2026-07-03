{ pkgs, config, ... }:
let
  # patch to use new lua dispatcher syntax
  # https://wiki.hypr.land/Configuring/Basics/Dispatchers/
  hyprmon = pkgs.hyprmon.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./hyprmon-lua-dispatch.patch ];
  });

  # map lua placeholders to store paths
  paths = {
    kitty = "${pkgs.kitty}/bin/kitty";
    rofi = "${pkgs.rofi}/bin/rofi";
    rofimoji = "${pkgs.rofimoji}/bin/rofimoji";
    hyprshot = "${pkgs.hyprshot}/bin/hyprshot";
    playerctl = "${pkgs.playerctl}/bin/playerctl";
    brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
    hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
    file_manager = "${pkgs.kitty}/bin/kitty --class yazi ${pkgs.yazi}/bin/yazi";
    hyprmon = "${hyprmon}/bin/hyprmon";
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

  programs.rofi = {
    enable = true;
    theme.window = {
      border = config.lib.formats.rasi.mkLiteral "1px";
      border-color = config.lib.formats.rasi.mkLiteral "@blue";
    };
  };

  services.hyprpolkitagent.enable = true;
}
