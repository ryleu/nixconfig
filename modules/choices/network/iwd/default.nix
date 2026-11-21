# iwd setup
{
  flake.modules.nixos.network-iwd = {
    networking.wireless = {
      # take wpa_supplicant out back (i hate wpa_supplicant with a burning passion)
      enable = false;

      iwd = {
        enable = true;
        settings = {
          IPv6.Enabled = true;
          Settings = {
            # auto connect to wifi
            AutoConnect = true;
            # fixes some issues with wpa2
            ControlPortOverNL80211 = false;
          };
        };
      };
    };
  };
}
