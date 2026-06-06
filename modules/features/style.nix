{
  flake.modules.homeManager.gui =
    {
      config,
      lib,
      pkgs,
      ...
    }:
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

      cursorName = "phinger-cursors-light";
      cursorSize = 32;

      iconsName = "Papirus-Dark";
    in
    {
      # fonts
      fonts.fontconfig = {
        enable = true;
        defaultFonts = {
          monospace = [ "FiraCode Nerd Font" ];
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
        # fonts
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
        vista-fonts
        carlito

        # qt
        adwaita-qt6
        adwaita-qt
      ];

      dconf.settings."org/gnome/desktop/interface" = {
        font-name = sans + " 10";
        monospace-font-name = mono + " 10";
        color-scheme = lib.mkDefault "prefer-dark";
      };

      # cursor
      home.sessionVariables = {
        XCURSOR_SIZE = cursorSize;
        HYPRCURSOR_SIZE = cursorSize;
      };
      home.pointerCursor = {
        enable = true;
        package = pkgs.phinger-cursors;
        dotIcons.enable = true;
        gtk.enable = true;
        hyprcursor = {
          enable = true;
          size = cursorSize;
        };
        name = cursorName;
        size = cursorSize;
        x11.enable = true;
      };

      # gtk + icons
      gtk = {
        enable = true;
        iconTheme = {
          name = iconsName;
          package = pkgs.papirus-icon-theme;
        };
        gtk3.extraConfig.gtk-icon-theme-name = iconsName;
        gtk4.extraConfig.Settings = "gtk-icon-theme-name=${iconsName}";
      };

      # qt
      qt = {
        enable = true;
        kde.settings = { };
        platformTheme.name = "adwaita";
        style.name = "adwaita-dark";
      };

      # kitty terminal
      programs.kitty = {
        enable = true;
        font = {
          name = mono;
          size = 13;
        };
        settings = {
          notify_on_cmd_finish = "invisible";
          disable_ligatures = "cursor";
          font_family = "family=\"${mono}\" features=\"${builtins.concatStringsSep " +" mono-features}\"";
        };
        shellIntegration.enableZshIntegration = true;
      };

      # xdg user dirs
      xdg.userDirs = {
        enable = true;
        # adopt the new HM default (was true under stateVersion < 26.05)
        setSessionVariables = false;
      };

      # shared face picture
      home.file.".face".source = ./face.png;
    };
}
