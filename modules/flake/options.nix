# a PART is something a machine can have:
#
#   flake.modules.nixos.<part>         its system half
#   flake.modules.homeManager.<part>   its home half
#
# either half is optional. a part can also declare:
#
#   settings.<part>   change how the part works
#   requires.<part>   declare dependencies
#   variants.<part>   declare multiple possible implementations for a part
#
# a HOST says which parts are plugged in and how each is set:
#
#   hosts.<name>.parts.<part> = { <setting> = <value>; };
#   hosts.<name>.users.<user>.parts.<part> = { ... };   # for that user only
{
  lib,
  inputs,
  config,
  ...
}:
let
  t = lib.types;

  nixos = config.flake.modules.nixos or { };
  home = config.flake.modules.homeManager or { };

  # need to figure out which parts are variants so we can filter them out
  isVariant = name: lib.any (part: lib.hasPrefix "${part}-" name) (lib.attrNames config.variants);

  # list of all of the parts that could be plugged in, sans variants
  partNames = lib.filter (name: !isVariant name) (
    lib.unique (
      lib.attrNames nixos
      ++ lib.attrNames home
      ++ lib.attrNames config.settings
      ++ lib.attrNames config.requires
    )
  );

  # every part needs to be marked as optional
  optional =
    settings:
    t.nullOr settings
    // {
      name = "submodule";
      substSubModules = m: optional (settings.substSubModules m);
    };

  # use those functions to define a completely typed set of parts
  partsType = t.submodule {
    options = lib.genAttrs partNames (
      name:
      lib.mkOption {
        type = optional (t.submodule (config.settings.${name} or { }));
        default = null;
        description = "Plug in ${name}, with these settings.";
      }
    );
  };
in
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  options = {
    settings = lib.mkOption {
      type = t.attrsOf t.deferredModule;
      default = { };
      description = "Settings that this part accepts.";
    };

    requires = lib.mkOption {
      type = t.attrsOf (t.listOf t.str);
      default = { };
      description = "Other parts that this part requires.";
    };

    variants = lib.mkOption {
      type = t.attrsOf (t.listOf t.str);
      default = { };
      description = "Settings whose value selects <part>-<value> to be included.";
    };

    helpers = lib.mkOption {
      type = t.attrsOf t.raw;
      default = { };
      description = "Global set of functions that more than one part uses.";
    };

    hosts = lib.mkOption {
      default = { };
      description = "The definition of a machine.";
      type = t.attrsOf (
        t.submodule {
          options = {
            stateVersion = lib.mkOption { type = t.str; };

            parts = lib.mkOption {
              type = partsType;
              default = { };
              description = "The parts included in the machine.";
            };

            users = lib.mkOption {
              default = { };
              description = "The users included in the machine.";
              type = t.attrsOf (
                t.submodule {
                  options.parts = lib.mkOption {
                    type = partsType;
                    default = { };
                    description = "Parts that this user gets the home-manager half of.";
                  };
                }
              );
            };

            modules = lib.mkOption {
              type = t.listOf t.deferredModule;
              default = [ ];
              description = "Additional NixOS modules specific to this machine.";
            };
          };
        }
      );
    };
  };
}
