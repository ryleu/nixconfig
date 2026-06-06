{ inputs, ... }:
{
  flake.modules.nixos.thinkpad-p14s =
    { pkgs, ... }:
    {
      imports = [
        # technically a gen6, but close enough
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen5
      ];

      # smart card
      services.pcscd.enable = true;
      environment.systemPackages = with pkgs; [
        pcsclite
        pcsc-tools
        opensc
        cacert
      ];

      # fingerprint scanner
      services.fprintd = {
        enable = true;
        tod = {
          enable = true;
          driver = pkgs.libfprint-2-tod1-goodix;
        };
      };
    };
}
