{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  calibrePlugins = inputs.calibre-plugins.packages.${pkgs.stdenv.hostPlatform.system};

  # give each plugin its .zip filename in one dir
  calibrePluginDir = pkgs.linkFarm "calibre-plugins" [
    {
      name = "ACSM_Input.zip";
      path = calibrePlugins.acsm-calibre-plugin;
    }
    {
      name = "DeDRM_plugin.zip";
      path = calibrePlugins.dedrm-plugin;
    }
  ];
in
{
  programs.calibre.enable = true;

  # nuke any imperatively installed plugins and re-register from the store if needed
  #home.activation.registerCalibrePlugins = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
  #  target=${calibrePluginDir}
  #  marker="$HOME/.local/state/home-manager/calibre-plugins-generation"
  #  if [ "$(readlink "$marker" 2>/dev/null)" != "$target" ]; then
  #    pluginDir="$HOME/.config/calibre/plugins"
  #    calibreCustomize=${config.programs.calibre.package}/bin/calibre-customize
  #    run rm -rf "$pluginDir"
  #    run mkdir -p "$pluginDir" "$(dirname "$marker")"
  #    for zip in "$target"/*.zip; do
  #      run "$calibreCustomize" -a "$zip"
  #    done
  #    run ln -sfn "$target" "$marker"
  #  fi
  #'';
}
