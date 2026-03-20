{
  description = "Configuration flake for ryleu's desktop";

  # shared configuration is stored in configuration.nix, while individual configs are in the files
  # named for the device's hostname. eg: rectangle uses configuration.nix and rectangle.nix

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    master_pkgs.url = "github:NixOS/nixpkgs/master";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";

    hardware.url = "github:nixos/nixos-hardware";
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        darwin.follows = ""; # save some space because nixos not darwin
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # work things
    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      # Small tool to iterate over each systems
      eachSystem =
        f: nixpkgs.lib.genAttrs (import inputs.systems) (system: f nixpkgs.legacyPackages.${system});

      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = eachSystem (pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      nixosConfigurations =
        let
          baseModules = [
            ./modules/nixos
            ./modules/home-manager
            {
              nixpkgs.overlays = [
                inputs.firefox-addons.overlays.default
              ];
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

          # ethernet-port's nixos configuration
          ethernet-port = nixpkgs.lib.nixosSystem {
            modules = baseModules ++ [
              ./modules/hardware/ethernet-port
            ];
            inherit specialArgs;
          };
        };

      # for nix fmt
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.wrapper);
      # for `nix flake check`
      checks = eachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.check self;
      });
    };
}
