{ inputs, ... }:
{
  flake.modules.homeManager.desktop =
    { ... }:
    {
      imports = [ inputs.mcwall.homeManagerModules.default ];
      services.mcwall.enable = true;
      services.awww.enable = true;
    };
}
