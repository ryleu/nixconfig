{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        undollar
        comma
        nix-search
        nixfmt
        ffmpeg-full
        secretspec
        mdfried # markdown viewer
      ];

      programs = {
        distrobox.enable = true;
        aria2.enable = true;
        gh.enable = true;
        nix-index.enable = true;
      };
    };
}
