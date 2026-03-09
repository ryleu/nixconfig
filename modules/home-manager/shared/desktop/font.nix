{ config, pkgs, ... }:
let
  mono = builtins.head config.fonts.fontconfig.defaultFonts.monospace;
  mono-features = [
    "liga"
    "calt"
    "cv01"
    "cv02"
    "cv04"
    "ss01"
    "ss06"
  ];
  sans = builtins.head config.fonts.fontconfig.defaultFonts.sansSerif;
  # serif = builtins.head config.fonts.fontconfig.defaultFonts.serif;
  # emoji = builtins.head config.fonts.fontconfig.defaultFonts.emoji;
in
{
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [
        "FiraCode Nerd Font"
      ];
      sansSerif = [
        "Noto Sans"
        "Unifont"
      ];
      serif = [
        "Noto Serif"
        "Unifont"
      ];
      emoji = [
        "Noto Color Emoji"
        "Unifont"
      ];
    };
  };

  home.packages = with pkgs; [
    nerd-fonts.fira-code
    minecraftia
    unifont
    source-code-pro
    corefonts
    comic-mono
    comic-neue
    font-awesome
    noto-fonts
    rubik
    corefonts
    vista-fonts
    carlito
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      font-name = sans + " 10";
      monospace-font-name = mono + " 10";
      color-scheme = pkgs.lib.mkDefault "prefer-dark";
    };
  };

  programs.kitty = {
    font = {
      name = mono;
      size = 13;
    };
    settings = {
      disable_ligatures = "cursor";
      font_family = "family=\"${mono}\" features=\"${builtins.concatStringsSep " +" mono-features}\"";
    };
  };
}
