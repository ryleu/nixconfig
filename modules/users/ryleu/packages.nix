# apps only ryleu uses
{
  flake.modules.homeManager.ryleu-apps =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # comms
        signal-desktop

        # utilities
        hugin # panoramas for URC
        twinejs # EH244

        # 2month
        (symlinkJoin {
          name = "arduino-ide";
          paths = [ arduino-ide ];
          buildInputs = [ makeWrapper ];
          # force xorg
          postBuild = ''
            wrapProgram $out/bin/arduino-ide --set ELECTRON_OZONE_PLATFORM_HINT x11
          '';
        })
        arduino-cli

        # cli
        whipper
        xwayland-satellite
      ];

      programs.yt-dlp.enable = true;
      programs.bun.enable = true;
    };
}
