{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      # i have literally only hit the power button accidentally or to hold it for 15 seconds
      services.logind.settings.Login.HandlePowerKey = "ignore";

      # gpu tuning daemon
      environment.systemPackages = with pkgs; [ lact ];
      systemd = {
        services.lactd.enable = true;
        packages = with pkgs; [ lact ];
      };

      # rgb peripherals
      services.hardware.openrgb = {
        enable = true;
        package = pkgs.openrgb-with-all-plugins;
      };
    };
}
