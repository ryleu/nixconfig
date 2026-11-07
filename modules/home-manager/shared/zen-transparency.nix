{
  config,
  lib,
  ...
}:
let
  opacity = "0.6";

  colors = config.lib.stylix.colors;

  rgba =
    base:
    "rgba(${colors."${base}-rgb-r"}, ${colors."${base}-rgb-g"}, ${colors."${base}-rgb-b"}, ${opacity})";

  userChrome = ''
    :root:root {
      --zen-themed-toolbar-bg-transparent: transparent !important;
      --zen-main-browser-background: ${rgba "base00"} !important;
      --zen-main-browser-background-toolbar: ${rgba "base00"} !important;
    }

    :root #zen-browser-background {
      --zen-main-browser-background: ${rgba "base00"} !important;
    }

    :root #zen-toolbar-background {
      --zen-main-browser-background-toolbar: ${rgba "base00"} !important;
    }

    :root #zen-workspaces-button {
      background-color: transparent !important;
    }
  '';

  settings = {
    "zen.widget.linux.transparency" = true;
    "zen.view.grey-out-inactive-windows" = false;
  };
in
{
  # apply to all profiles
  programs.zen-browser.profiles = lib.genAttrs config.stylix.targets.zen-browser.profileNames (_: {
    inherit settings userChrome;
  });
}
