# move cameras from iphone
{
  flake.modules.nixos.dev =
    { pkgs, ... }:
    {
      services.usbmuxd.enable = true;

      environment.systemPackages = with pkgs; [
        libimobiledevice
        ifuse
      ];
    };
}
