{
  flake.modules.nixos.base = { lib, pkgs, ... }: {
    boot = {
      # magic sysrq, for when the machine locks up
      kernel.sysctl."kernel.sysrq" = 1;

      # default kernel
      kernelPackages = lib.mkDefault pkgs.linuxPackages;
    };
  };
}
