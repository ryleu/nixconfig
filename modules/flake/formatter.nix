# nix fmt / nix flake check
{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem.treefmt = {
    projectRootFile = "flake.nix";

    programs = {
      nixfmt.enable = true;
      stylua = {
        enable = true;
        settings = {
          indent_type = "Spaces";
          indent_width = 4;
        };
      };

      statix.enable = true;
      deadnix.enable = true;
    };
  };
}
