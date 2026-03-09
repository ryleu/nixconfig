{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    # https://wiki.hyprland.org/Configuring/Variables/#input
    input = {
      kb_layout = "us";
      kb_variant = "";
      kb_model = "";
      kb_options = "";
      kb_rules = "";

      follow_mouse = 1;
      accel_profile = "adaptive";
      sensitivity = 0.2; # -1.0 - 1.0, 0 means no modification.

      touchpad = {
        natural_scroll = true;
        clickfinger_behavior = true;
        tap-to-click = true;
      };
    };

    device = [
      {
        # evil mouse at work that moves at 1 pixel per mile
        name = "logitech-optical-usb-mouse";
        sensitivity = 1.0;
      }
    ];
  };
}
