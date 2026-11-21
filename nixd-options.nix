# nixd options
let
  flake = builtins.getFlake "/etc/nixos";

  parts = flake.inputs.flake-parts.lib.evalFlakeModule {
    inputs = flake.inputs // {
      self = flake;
    };
  } (flake.inputs.import-tree /etc/nixos/modules);

  inherit (flake.inputs.nixpkgs) lib;

  # lay option trees over each other, stopping at each option
  overlay = lib.foldl' (lib.recursiveUpdateUntil (
    _: left: right:
    left ? _type || right ? _type
  )) { };

  # the options of every host, so that no host is singled out and an option
  # only one of them has is still found
  everyHost =
    optionsOf: overlay (map optionsOf (lib.attrValues parts.config.flake.nixosConfigurations));

  nixos = everyHost (host: host.options);
  homeManager = everyHost (host: host.options.home-manager.users.type.getSubOptions [ ]);

  # nixd walks options by their type names. this stands in for "modules by
  # name", so that under flake.modules.<class>.<name> it finds that class's
  # options
  modulesOf = options: {
    _type = "option";
    type = {
      name = "attrsOf";
      nestedTypes.elemType = {
        name = "submodule";
        getSubOptions = _: options;
      };
    };
  };
in
overlay [
  # nixd loses the path above a `let` or a list, and then looks an option up
  # from the top. so both classes are at the top as well, the system's
  # winning where they share a name
  homeManager
  nixos

  # this flake's own vocabulary: hosts, parts and their settings
  parts.options

  # what the part files are written in
  {
    flake.modules = {
      nixos = modulesOf nixos;
      homeManager = modulesOf homeManager;
    };
  }
]
