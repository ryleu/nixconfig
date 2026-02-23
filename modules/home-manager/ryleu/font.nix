{ pkgs, ... }:
let
  mono = {
    family = "FiraCode Nerd Font";
    features = [
      "liga"
      "calt"
      "cv01"
      "cv02"
      "cv04"
      "ss01"
      "ss06"
    ];
  };
  sans.family = "Noto Sans";
  serif.family = "Noto Serif";
  emoji.family = "Noto Color Emoji";
  fallback.family = "Unifont";
in
{
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
      font-name = sans.family + " 10";
      monospace-font-name = mono.family + " 10";
      color-scheme = pkgs.lib.mkDefault "prefer-dark";
    };
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [
        mono.family
      ];
      sansSerif = [
        sans.family
        fallback.family
      ];
      serif = [
        serif.family
        fallback.family
      ];
      emoji = [
        emoji.family
        fallback.family
      ];
    };
  };

  programs.kitty = {
    font = {
      name = mono.family;
      size = 13;
    };
    settings = {
      disable_ligatures = "cursor";
      font_family =
        "family=\"${mono.family}\" features=\"" + (builtins.concatStringsSep " +" mono.features) + "\"";
    };
  };
}
