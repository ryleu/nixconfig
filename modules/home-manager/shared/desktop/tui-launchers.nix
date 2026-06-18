{ pkgs, lib, ... }:
let
  # tui stuff in kitty windows
  mkTuiLauncher = commonName: pkg: {
    name = "${commonName} (${pkg.pname})";
    exec = "${pkgs.kitty}/bin/kitty --class ${pkg.pname} ${lib.getExe pkg}";
    type = "Application";
  };
in
{
  # Re-expose for per-user modules (ryleu, wyleu) via _module.args.
  _module.args.mkTuiLauncher = mkTuiLauncher;

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
  };
}
