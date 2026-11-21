# turn tui apps into desktop apps
{ config, ... }:
{
  helpers.mkTuiLauncher = pkgs: commonName: pkg: {
    name = "${commonName} (${pkg.pname})";
    exec = "${pkgs.kitty}/bin/kitty --class ${pkg.pname} ${pkgs.lib.getExe pkg}";
    type = "Application";
  };

  flake.modules.homeManager.desktop =
    { pkgs, lib, ... }:
    let
      mkTuiLauncher = config.helpers.mkTuiLauncher pkgs;
    in
    {
      home.packages = with pkgs; [
        wiremix # tui audio mixer
        gdu # tui disk usage
        impala
        bluetui
        wl-clipboard
      ];

      xdg.desktopEntries = {
        # set up yazi as the directory mime guy
        yazi = {
          name = "File Manager (${pkgs.yazi.pname})";
          exec = "${pkgs.kitty}/bin/kitty --class yazi ${lib.getExe pkgs.yazi} %F";
          mimeType = [ "inode/directory" ];
          type = "Application";
        };

        # nvim mime for text editing
        nvim = {
          name = "Text Editor (${pkgs.neovim.pname})";
          exec = "${pkgs.kitty}/bin/kitty --class neovim ${lib.getExe pkgs.neovim} %F";
          type = "Application";
        };

        wiremix = mkTuiLauncher "Audio Mixer" pkgs.wiremix;
        gdu = mkTuiLauncher "Disk Usage" pkgs.gdu;
        impala = mkTuiLauncher "WiFi" pkgs.impala;
        bluetui = mkTuiLauncher "Bluetooth" pkgs.bluetui;
        btop = mkTuiLauncher "System Monitor" pkgs.btop-rocm;
      };
    };
}
