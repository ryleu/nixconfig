{
  description = "Configuration flake for ryleu's desktop";

  # shared configuration is stored in configuration.nix, while individual configs are in the files
  # named for the device's hostname. eg: rectangle uses configuration.nix and rectangle.nix

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs_unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        darwin.follows = ""; # save some space because nixos not darwin
      };
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs_unstable,
      agenix,
      ...
    }@inputs:
    {
      nixosConfigurations =
        let
          system = "x86_64-linux";
          baseModules = [
	    ./modules/nixos
            agenix.nixosModules.default
            {
              environment.systemPackages = [ agenix.packages.${system}.default ];
            }
          ];
	  specialArgs = {
	    inherit inputs;
	  };
        in
        {
          # rectangle's nixos configuration
          rectangle = nixpkgs.lib.nixosSystem {
            modules = baseModules ++ [
              ./modules/hardware/rectangle
            ];
	    inherit specialArgs;
          };

          # barely-better's nixos configuration
          barely-better = nixpkgs.lib.nixosSystem {
            modules = baseModules ++ [
              ./modules/hardware/barely-better
            ];
	    inherit specialArgs;
          };
        };
    };
}
