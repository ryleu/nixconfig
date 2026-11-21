# colours, fonts, cursor and icons, through stylix
{
  flake.modules.homeManager.base = {
    imports = [
      (
        { config, ... }:
        {
          home.pointerCursor = {
            hyprcursor = {
              enable = true;
              size = config.home.pointerCursor.size;
            };
            dotIcons.enable = true;
          };
        }
      )
      (
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
            sitelen-seli-kiwen
          ];

          fonts.fontconfig.defaultFonts = {
            sansSerif = lib.mkAfter [ "Unifont" ];
            serif = lib.mkAfter [ "Unifont" ];
            emoji = lib.mkAfter [ "Unifont" ];
          };

          programs.kitty.settings = {
            disable_ligatures = "cursor";
            font_family = lib.mkForce ''family="${config.stylix.fonts.monospace.name}" features="+liga +calt +cv01 +cv02 +cv04 +ss01 +ss06 +ss08"'';
          };
        }
      )
    ];
  };

  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      stylix = {
        enable = true;

        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

        polarity = "dark";

        opacity = {
          terminal = 0.85;
          desktop = 0.85;
        };

        fonts = {
          monospace = {
            name = "FiraCode Nerd Font";
            package = pkgs.nerd-fonts.fira-code;
          };
          sansSerif = {
            name = "Noto Sans";
            package = pkgs.noto-fonts;
          };
          serif = {
            name = "Noto Serif";
            package = pkgs.noto-fonts;
          };
          emoji = {
            name = "Noto Color Emoji";
            package = pkgs.noto-fonts-color-emoji;
          };
        };

        cursor = {
          #name = "phinger-cursors-light";
          #package = pkgs.phinger-cursors;
          name = "Bibata-Modern-Ice";
          package = pkgs.bibata-cursors;
          size = 32;
        };

        icons = {
          enable = true;
          package = pkgs.papirus-icon-theme;
          dark = "Papirus-Dark";
          light = "Papirus";
        };
      };
    };
}
