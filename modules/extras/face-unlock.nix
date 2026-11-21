# face recognition on the infrared camera
{
  settings.face-unlock =
    { lib, ... }:
    {
      options = {
        camera = lib.mkOption {
          type = lib.types.str;
          description = "The infrared camera used for authentication. Provide a /dev/v4l/by-path/ name.";
        };
        darkThreshold = lib.mkOption {
          type = lib.types.ints.between 0 100;
          description = "The threshold for considering a frame dark.";
          default = 97;
        };
      };
    };

  flake.modules.nixos.face-unlock =
    { config, lib, ... }:
    {
      # face recognition
      services.howdy = {
        enable = true;
        control = "sufficient";
        settings.video = {
          device_path = config.parts.face-unlock.camera;
          dark_threshold = config.parts.face-unlock.darkThreshold;
        };
      };

      security.pam = {
        # only enabled for specific things
        howdy.enable = false;

        services = {
          # enable for polkit
          polkit-1.howdy.enable = true;

          # enable for hyprlock
          hyprlock = {
            howdy.enable = true;
            rules.auth.howdy.order = lib.mkForce (
              # after hyprlock unlock
              config.security.pam.services.hyprlock.rules.auth.unix.order + 10
            );
          };
        };
      };

      # let polkit sandbox access the ir camera
      systemd.services."polkit-agent-helper@".serviceConfig = {
        PrivateDevices = false;
        DeviceAllow = [ "char-video4linux rw" ];
      };
    };
}
