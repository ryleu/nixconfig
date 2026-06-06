{ inputs, ... }:
{
  flake.modules.nixos.amd-graphics =
    { pkgs, ... }:
    {
      imports = [ inputs.nixos-hardware.nixosModules.common-gpu-amd ];

      boot = {
        initrd.kernelModules = [ "amdgpu" ];
        kernelModules = [
          "i2c-dev"
          "i2c-piix4"
        ];
      };

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          mesa.opencl
          amf
        ];
      };

      environment.variables.RUSTICL_ENABLE = "radeonsi";
    };
}
