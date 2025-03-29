{
  description = "Configuration flake for ryleu's desktop";

  # shared configuration is stored in configuration.nix, while individual configs are in the files
  # named for the device's hostname. eg: rectangle uses configuration.nix and rectangle.nix

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs_unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs_unstable, ... }@inputs: {
    nixosConfigurations = let
        system = "x86_64-linux";
        baseModules = [
          ./configuration.nix
        ];
    in {
      # default configuration
      nixos = nixpkgs.lib.nixosSystem {
        modules = baseModules;
      };

      # rectangle's nixos configuration
      rectangle = nixpkgs.lib.nixosSystem {
        modules = baseModules ++ [
          ./hosts/rectangle.nix
        ];
      };

      # mathrock's nixos configuration
      mathrock = nixpkgs.lib.nixosSystem {
        modules = baseModules ++ [
          ./hosts/mathrock.nix
        ];
      };

      # barely-better's nixos configuration
      barely-better = nixpkgs.lib.nixosSystem {
        modules = baseModules ++ [
          ./hosts/barely-better.nix
        ];
      };
    };
  };
}

