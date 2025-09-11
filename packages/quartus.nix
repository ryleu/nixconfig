{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ quartus-prime-lite ];

  services.udev.packages = with pkgs; [ usb-blaster-udev-rules ];
}
