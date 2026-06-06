{ config, inputs, ... }:
{
  flake.modules.nixos = {
    base = {
      imports = [ (inputs.home-manager + "/nixos") ];

      home-manager = {
        backupFileExtension = "bak";
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };

    ryleu.home-manager.users.ryleu = config.flake.modules.homeManager.ryleu;
    wyleu.home-manager.users.wyleu = config.flake.modules.homeManager.wyleu;
  };
}
