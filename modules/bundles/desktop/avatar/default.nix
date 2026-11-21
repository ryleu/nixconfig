{
  flake.modules.homeManager.desktop = _: {
    home.file = {
      ".face".source = ./face.png;
    };
  };
}
