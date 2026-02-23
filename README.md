# nixconfig

nixos & eventually home manager configuration for my machines.

## contents

most of the relevant stuff is in [`./modules`](./modules).

here's a breakdown of what goes where:

- [`./modules/hardware`](./modules/hardware) -- device / hardware-specific
  configuration. `hardware-configuration.nix` goes here, along with kernel modules
  and other related things.
- [`./modules/home-manager`](./modules/home-manager) -- home manager stuff.
- [`./modules/nixos`](./modules/nixos) -- nixos modules go here.

## general ideas

- i use flakes.
- i have multiple very disperate machines (some graphical, some not).
- it should be intuitive to navigate.
- it should be easy to add more users in the future.

i execute on very few of these.

