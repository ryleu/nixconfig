{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    minecraftia
    unifont
    source-code-pro
    corefonts
    comic-mono
    comic-neue
    font-awesome
    rubik
    vista-fonts
    carlito
  ];

  fonts.fontconfig.defaultFonts = {
    sansSerif = lib.mkAfter [ "Unifont" ];
    serif = lib.mkAfter [ "Unifont" ];
    emoji = lib.mkAfter [ "Unifont" ];
  };

  programs.kitty.settings = {
    disable_ligatures = "cursor";
    font_family = lib.mkForce ''family="${config.stylix.fonts.monospace.name}" features="+liga +calt +cv01 +cv02 +cv04 +ss01 +ss06"'';
  };
}
