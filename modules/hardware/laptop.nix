{ inputs, pkgs, ... }:

{
  imports = [
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.logind = {
    settings.Login = {
      HandleLidSwitch = "suspend-then-hibernate";
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "suspend-then-hibernate";
    };
  };
}
