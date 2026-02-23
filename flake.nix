{
  description = "Configuration flake for ryleu's desktop";

  # shared configuration is stored in configuration.nix, while individual configs are in the files
  # named for the device's hostname. eg: rectangle uses configuration.nix and rectangle.nix

  inputs =
    {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

      hardware.url = "github:nixos/nixos-hardware";
      agenix = {
        url = "github:ryantm/agenix";
        inputs = {
          nixpkgs.follows = "nixpkgs";
          darwin.follows = ""; # save some space because nixos not darwin
        };
      };

      # home-manager = {
      #   url = "github:nix-community/home-manager/release-25.11";
      #   inputs.nixpkgs.follows = "nixpkgs";
      # };

      # zen-browser = {
      #   url = "github:0xc000022070/zen-browser-flake";
      #   inputs.nixpkgs.follows = "nixpkgs";
      # };
      # firefox-addons = {
      #   url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      #   inputs.nixpkgs.follows = "nixpkgs";
      # };
    };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    {
      nixosConfigurations =
        let
          baseModules = [
            ./modules/nixos
	    #./modules/home-manager
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
