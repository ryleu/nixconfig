# keyboard configuration / mcu flashing
{
  flake.modules.nixos.dev =
    { pkgs, ... }:
    {
      hardware = {
        keyboard.qmk.enable = true;
        i2c.enable = true;
      };

      services.udev.packages = with pkgs; [
        via
        platformio-core
        openocd
      ];

      environment.systemPackages = with pkgs; [
        qmk
        via
      ];
    };
}
