{
  flake.modules.nixos.laptop.services.logind.settings.Login = {
    HandlePowerKey = "hibernate";
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "suspend-then-hibernate";
  };
}
