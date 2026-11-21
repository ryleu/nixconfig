# tui session manager
{
  flake.modules.nixos.session-greeter =
    { config, pkgs, ... }:
    {
      services.greetd = {
        enable = true;
        settings.default_session.command = builtins.replaceStrings [ "\n" ] [ "" ] ''
          ${pkgs.tuigreet}/bin/tuigreet
            --time
            --remember
            --remember-user-session
            --user-menu
            --asterisks
            --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions
            --xsessions ${config.services.displayManager.sessionData.desktops}/share/xsessions
        '';
      };
    };
}
