{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem = _: {
    treefmt = {
      projectRootFile = "flake.nix";
      programs.nixfmt.enable = true;
      programs.stylua = {
        enable = true;
        settings = {
          indent_type = "Spaces";
          indent_width = 4;
        };
      };
    };
  };
}
