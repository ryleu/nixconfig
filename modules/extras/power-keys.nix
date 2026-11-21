# suspend instead of powering off when the power button is pressed
{
  flake.modules.nixos.power-keys = {
    services.logind.settings.Login = {
      HandlePowerKey = "suspend";
    };
  };
}
