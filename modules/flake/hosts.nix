# turns every host record into a nixosConfiguration
{
  inputs,
  config,
  lib,
  ...
}:
let
  nixos = config.flake.modules.nixos or { };
  home = config.flake.modules.homeManager or { };

  # list of set.$name for name in names if set.$name exists
  # flatten set into list of configuration options
  pick = set: names: map (name: set.${name}) (lib.filter (name: set ? ${name}) names);

  # recurively collect parts and their dependencies into a deduplicated list of names
  withRequired =
    names:
    let
      more = lib.unique (
        # deduplicate
        # collect names of parts and their immediate dependencies into a flat list
        names ++ lib.concatMap (n: config.requires.${n} or [ ]) names
      );
    in
    # recursively check for dependencies again if we found any
    if more == names then names else withRequired more;

  # find the settings for a part, throw an error for any required setting that is not set
  settingsFor =
    label: plugged: name: # label for errors, `parts` block from the host record, name of the specific part
    let
      # grab the part's settings
      set = plugged.${name} or null;
      # get the part's settings when nothing is set (aka the defaults)
      defaults = (lib.evalModules { modules = [ (config.settings.${name} or { }) ]; }).config;
      # choose `set`, fall back to `defaults`, remove "_module"
      values = removeAttrs (if set != null then set else defaults) [ "_module" ];
      # get a list of settings that fail to evaluate (aka unset, required settings)
      unset = lib.filter (
        setting: !(builtins.tryEval (builtins.deepSeq values.${setting} true)).success
      ) (lib.attrNames values);
    in
    if unset == [ ] then
      values
    else
      throw "${label}: the '${name}' part needs ${
        lib.concatMapStringsSep ", " (k: "${name}.${k}") unset
      } set";

  # resolves a host's (or user's) parts
  # includes named parts (both bundles and extras), required parts, and implementations for variant parts
  resolve =
    label: plugged: extra:
    let
      # get the names of all named parts
      named = extra ++ lib.attrNames (lib.filterAttrs (_: v: v != null) plugged);
      # add their deps
      parts = withRequired named;
      # find their settings, { name -> settings for each part }
      settings = lib.genAttrs parts (settingsFor label plugged);
      # flatten the chosen options to "choice-implementation", i.e. "network-networkd"
      chosen = lib.concatMap (
        part:
        map (setting: "${part}-${toString settings.${part}.${setting}}") (config.variants.${part} or [ ])
      ) parts;
    in
    {
      inherit parts settings;
      names = parts ++ chosen;
    };

  # declares config.parts.<part> for each part named in only.
  # this lets parts actually read their settings
  settingsModule =
    resolved: only:
    { lib, ... }:
    {
      # declares the option for each name
      options.parts = lib.genAttrs only (
        name:
        lib.mkOption {
          type = lib.types.submodule (config.settings.${name} or { });
          description = "Settings for ${name}, from the host record.";
        }
      );
      # sets the option for each name
      config.parts = lib.genAttrs only (name: resolved.settings.${name});
    };

  build =
    name: host:
    let
      machine = resolve "host ${name}" host.parts [ ];

      # get { user -> parts } for each user (sans what the machine already has)
      perUser = lib.mapAttrs (
        user: cfg:
        let
          resolved = resolve "host ${name}, user ${user}" cfg.parts [ user ];
          only = lib.subtractLists machine.parts resolved.parts;
        in
        {
          inherit resolved only;
          names = lib.subtractLists machine.names resolved.names;
        }
      ) host.users;

      # get a list of unique usernames
      userNames = lib.unique (lib.concatMap (u: u.names) (lib.attrValues perUser));
    in
    inputs.nixpkgs.lib.nixosSystem {
      modules =
        pick nixos (machine.names ++ userNames) # pick the machine's parts and its users
        ++ host.modules # add the host-specific modules
        ++ [
          inputs.home-manager.nixosModules.home-manager # and the home manager nixos module
          inputs.stylix.nixosModules.stylix # and then stylix nixos module
          (settingsModule machine machine.parts) # and the module for the machine's settings
          {
            # and finally some extras
            networking.hostName = name;
            system.stateVersion = host.stateVersion;

            # home manager shared and per-user modules, plus their settings modules
            home-manager.sharedModules = pick home machine.names ++ [ (settingsModule machine machine.parts) ];
            home-manager.users = lib.mapAttrs (_: u: {
              imports = pick home u.names ++ [ (settingsModule u.resolved u.only) ];
            }) perUser;
          }
        ];
    };
in
{
  flake.nixosConfigurations = lib.mapAttrs build config.hosts;
}
