{ inputs, ... }:
{
  flake.modules.homeManager.desktop =
    { pkgs, config, ... }:
    let
      # our patched build, from modules/packages/hyprmon-lua
      hyprmon = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.hyprmon-lua;

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
        cyan = "rgb(${config.lib.stylix.colors.base0C})";
      };

      substitute =
        template:
        builtins.replaceStrings (map (n: "@${n}@") (
          builtins.attrNames paths
        )) (builtins.attrValues paths) template;
    in
    {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = true;
        configType = "lua";

        extraConfig = substitute (builtins.readFile ./hyprland.lua);
      };
    };

  flake.modules.nixos.desktop = {
    programs = {
      # enable hyprland
      hyprland = {
        enable = true;
        xwayland.enable = true;

        # on, but not used: we log into the plain "hyprland" session, not
        # "hyprland-uwsm". without this flag nixos rebuilds hyprland with
        # uwsm support stripped out, and that variant is not in the binary
        # cache, so it would compile here on every hyprland update.
        #
        # TODO: look into actually using uwsm. it runs the session as
        # systemd units (proper graphical-session.target, clean shutdown,
        # apps in their own scopes). adopting it means moving off
        # home-manager's own hyprland systemd integration, which the bar and
        # the bitwarden service currently hang off.
        withUWSM = true;
      };
    };

    services.xserver.enable = false;
  };
}
