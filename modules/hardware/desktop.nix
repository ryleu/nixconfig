{ inputs, ... }:
{
  imports = [
    inputs.hardware.nixosModules.common-gpu-amd
  ];
}
