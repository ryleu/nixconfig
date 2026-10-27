{ ... }:
{
  services.swaync = {
    enable = true;
    settings = {
      timeout = 5;

      positionX = "center";
      positionY = "top";

      control-center-positionX = "right";
      control-center-positionY = "top";

      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
    };

    style = ''
      :root {
        --border-radius: 0px;
        --notification-shadow: none;
        --mpris-album-art-shadow: none;
      }

      window,
      .floating-notifications,
      .notification-row,
      .notification-background,
      .control-center,
      .blank-window {
        box-shadow: none;
        -gtk-icon-shadow: none;
        text-shadow: none;
      }

      .close-button {
        border-radius: 0px;
      }

      .notification.low,
      .notification.normal,
      .notification.critical,
      .control-center {
        border-width: 2px;
      }

      .notification {
        margin: 0;
        background: @base00;
      }

      .notification-default-action {
        padding: 0;
        margin: 0;
      }

      .notification-row .notification-background {
        padding: 0;
      }

      .notification-content {
        margin: 0;
        padding: 6px;
        border: none;
      }
    '';
  };
}
