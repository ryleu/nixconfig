{ inputs, ... }:

{
  imports = [
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  services.logind = {
    settings.Login = {
      HandleLidSwitch = "suspend-then-hibernate";
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "suspend-then-hibernate";
    };
  };
}
