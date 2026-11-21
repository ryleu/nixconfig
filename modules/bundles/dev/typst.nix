{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        typst
        typstyle
        typst-live
      ];
    };
}
