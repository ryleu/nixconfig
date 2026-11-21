# nixconfig

nixos & home manager configuration for my machines.

## contents

config is in [`./modules`](./modules), as flake-parts modules.

you can read up on my hardware [here](./hardware/README.md).

- [`./modules/hosts`](./modules/hosts) -- computers
- [`./modules/bundles`](./modules/bundles) -- preset groups of parts
- [`./modules/choices`](./modules/choices) -- parts with multiple implementations
- [`./modules/extras`](./modules/extras) -- extra parts
- [`./modules/users`](./modules/users) -- parts for users
- [`./modules/packages`](./modules/packages) -- custom and patched packages
- [`./modules/flake`](./modules/flake) -- hurt my brain

## installing a new machine

```sh
sudo disko-install --flake .#<host> --disk main /dev/<device>
```

## secure boot & tpm unlocking

### secure boot

1. install and boot once to generate keys.
2. rebuild system and make sure the keys work:

   ```sh
   sudo nixos-rebuild switch --flake /etc/nixos#<host>
   sudo sbctl verify
   ```

3. reboot again to make sure the bootloader works.
4. put the firmware in setup mode. on a thinkpad: Security -> Secure Boot, enable
   secure boot, then "Reset to Setup Mode".
5. enroll the keys:

   ```sh
   sudo sbctl enroll-keys --microsoft
   ```

   unlock efivars and enroll again if needed:

   ```sh
   sudo nix shell nixpkgs#e2fsprogs -c chattr -i /sys/firmware/efi/efivars/<name>
   ```

6. reboot. `bootctl status` should say `Secure Boot: enabled (user)`.

### unlocking the disk with the tpm

```sh
sudo systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto \
  --tpm2-pcrs=7+15:sha256=0000000000000000000000000000000000000000000000000000000000000000 \
  --tpm2-with-pin=yes \
  /dev/disk/by-partlabel/disk-main-root
```

## general ideas

- i use flakes.
- i have multiple very disperate machines (some graphical, some not).
- it should be intuitive to navigate.
- it should be easy to add more users in the future.
- it should support nix darwin

i execute on very few of these.
