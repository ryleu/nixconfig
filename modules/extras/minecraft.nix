{
  flake.modules.homeManager.minecraft =
    { pkgs, lib, ... }:
    {
      home.packages = with pkgs; [
        packwiz
        (prismlauncher.override {
          # fix issues with some mods
          additionalLibs = with pkgs; [
            # x11 rendering for fabric crash window
            libxi
            libxfixes
            libxtst
            libxscrnsaver

            # java awt (libawt_xawt, libjawt, libfontmanager)
            libxrender
            freetype

            # webrtc-java (e4mc & friendslistbackport)
            libxcomposite
            dbus

            # lwjgl nfd file dialogs (axiom) and flatlaf
            gtk3
            glib
          ];
        })

      ];

      programs.zsh.completionInit = lib.mkAfter ''
        eval `${pkgs.packwiz}/bin/packwiz completion zsh`
      '';
    };

  flake.modules.nixos.minecraft = {
    networking.firewall.allowedTCPPorts = [
      25565 # minecraft
    ];
  };
}
