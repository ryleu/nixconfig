{ pkgs, lib, ... }:
let
  # tui stuff in kitty windows
  mkTuiLauncher = pkg: {
    name = pkg.pname;
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
      name = pkgs.yazi.pname;
      exec = "${pkgs.kitty}/bin/kitty --class yazi ${lib.getExe pkgs.yazi} %F";
      mimeType = [ "inode/directory" ];
      type = "Application";
    };

    # nvim mime for text editing
    nvim = {
      name = pkgs.neovim.pname;
      exec = "${pkgs.kitty}/bin/kitty --class neovim ${lib.getExe pkgs.neovim} %F";
      type = "Application";
    };

    wiremix = mkTuiLauncher pkgs.wiremix;
    gdu = mkTuiLauncher pkgs.gdu;
  };
}
