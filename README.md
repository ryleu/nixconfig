# nixconfig

nixos & home manager configuration for my machines.

## contents

most of the relevant stuff is in [`./modules`](./modules).

you can read up on my hardware [here](./hardware/README.md).

here's a breakdown of what goes where:

- [`./modules`](./modules) -- everything is auto-imported by
  [import-tree](https://github.com/vic/import-tree). computers are made of
  presets, presets are made of features.
- [`./modules/features`](./modules/features) -- small bits
  (hyprland, syncthing, shell, etc.).
- [`./modules/presets`](./modules/presets) -- bit bundles (bytes?).
- [`./modules/computers`](./modules/computers) -- one file per machine.
  declares `configurations.nixos.<name>.module` and imports the presets it
  wants.
- [`./modules/secrets`](./modules/secrets) -- agenix secrets.
- [`./agenix`](./agenix) -- agenix configuration.

## general ideas

- i use flakes.
- i have multiple very disperate machines (some graphical, some not).
- it should be intuitive to navigate.
- it should be easy to add more users in the future.
- it should support nix darwin

i execute on very few of these.
