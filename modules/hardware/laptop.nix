{ inputs, pkgs, ... }:

{
  imports = [
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  services.logind = {
    settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "suspend";
    };
  };
}
