{
  flake.modules.nixos.base =
    {
      pkgs,
      config,
      ...
    }:
    let
      colors = config.lib.stylix.colors;
      hostName = config.networking.hostName;

      rgb = name: "${colors."${name}-dec-r"}, ${colors."${name}-dec-g"}, ${colors."${name}-dec-b"}";

      # themed boot splash
      theme = pkgs.runCommand "plymouth-theme-tuigreet" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
        dir=$out/share/plymouth/themes/tuigreet
        mkdir -p $dir

        # borders / backgrounds are scaled up images
        magick -size 1x1 xc:'#${colors.base05}' PNG32:$dir/fg.png
        magick -size 1x1 xc:'#${colors.base00}' PNG32:$dir/bg.png

        substitute ${./tuigreet.script} $dir/tuigreet.script \
          --subst-var-by bg '${rgb "base00"}' \
          --subst-var-by fg '${rgb "base05"}' \
          --subst-var-by error '${rgb "base08"}' \
          --subst-var-by font 'FiraCode Nerd Font Mono' \
          --subst-var-by hostName '${hostName}'

        cat > $dir/tuigreet.plymouth <<EOF
        [Plymouth Theme]
        Name=tuigreet
        ModuleName=script

        [script]
        ImageDir=$dir
        ScriptFile=$dir/tuigreet.script
        EOF
      '';
    in
    {
      # don't need the stylix theme
      stylix.targets.plymouth.enable = false;

      boot.plymouth = {
        enable = true;
        theme = "tuigreet";
        themePackages = [ theme ];
        # add FiraCode to initrd
        font = "${pkgs.nerd-fonts.fira-code}/share/fonts/truetype/NerdFonts/FiraCode/FiraCodeNerdFontMono-Regular.ttf";
      };
    };
}
