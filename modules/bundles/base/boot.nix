# lanzaboote is systemd-boot signed for secureboot
{ inputs, ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      imports = [
        inputs.lanzaboote.nixosModules.lanzaboote
      ];

      boot = {
        lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
          autoGenerateKeys.enable = true;
        };

        # pipe down the kernel. looks bad on plymouth
        consoleLogLevel = 3;
        kernelParams = [
          "quiet"
          "udev.log_level=3"
          "systemd.show_status=auto"
        ];

        loader = {
          efi.canTouchEfiVariables = true;
          # hold space for timeout
          timeout = 0;
        };
      };

      environment.systemPackages = [ pkgs.sbctl ];
    };
}
