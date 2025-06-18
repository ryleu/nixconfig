{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # clamav
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
    scanner.enable = true;
    # Provides extra signatures
    fangfrisch.enable = true;
  };
}
