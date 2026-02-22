{ pkgs, ... }:
{
  ## TIMEZONE ##
  # ensure tz is not managed by nix
  time.timeZone = pkgs.lib.mkForce null;

  services = {
    automatic-timezoned.enable = true;
    geoclue2 = {
      geoProviderUrl = "https://api.beacondb.net/v1/geolocate";
      enableDemoAgent = pkgs.lib.mkForce true;
      enableWifi = true;
    };
  };

  ## LOCALIZATION ##
  # locale settings
  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # x keymap settings
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
