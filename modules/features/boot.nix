{
  flake.modules.nixos.base =
    { lib, pkgs, ... }:
    {
      boot = {
        kernelPackages = pkgs.linuxPackages;

        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };

        kernelModules = lib.mkDefault [
          "i2c-dev"
          "hid-playstation"
          "hidp"
        ];
        kernel.sysctl."kernel.sysrq" = 1;

        # copyfail mitigation
        blacklistedKernelModules = [
          "algif_aead"
          "esp4"
          "esp6"
          "rxrpc"
        ];
        extraModprobeConfig = ''
          install algif_aead /bin/false
          install esp4 /bin/false
          install esp6 /bin/false
          install rxrpc /bin/false
        '';
      };
    };
}
