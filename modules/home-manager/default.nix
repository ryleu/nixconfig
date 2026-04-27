{ config, inputs, ... }:
let
  withShared =
    module:
    (
      { ... }:
      {
        imports = [
          ./shared
          module
        ];
      }
    );
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.backupFileExtension = "bak";
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        inherit inputs;
      };

      # by-user
      home-manager.users.ryleu = withShared ./ryleu;
      home-manager.users.wyleu = withShared ./wyleu;
    }
  ];
}
