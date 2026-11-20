# nixconfig

nixos & home manager configuration for my machines.

## contents

most of the relevant stuff is in [`./modules`](./modules).

you can read up on my hardware [here](./hardware/README.md).

here's a breakdown of what goes where:

- [`./modules/hardware`](./modules/hardware) -- device / hardware-specific
  configuration. `hardware-configuration.nix` goes here, along with kernel modules
  and other related things.
- [`./modules/home-manager`](./modules/home-manager) -- home manager stuff.
- [`./modules/nixos`](./modules/nixos) -- nixos modules go here.

## secure boot & tpm unlocking

machines that import [`./modules/hardware/secureboot`](./modules/hardware/secureboot)
boot with secure boot enforced, using my own keys.

### how it works

- [lanzaboote](https://github.com/nix-community/lanzaboote) replaces the systemd-boot
  module. on every rebuild it signs the bootloader and one stub per generation. the
  stub carries the hashes of its kernel and initrd, which is why `sbctl verify` says
  the `kernel-*.efi` files are unsigned. that's expected.
- there is one set of keys (PK, KEK, db) shared by every machine. the private halves
  are agenix secrets in [`./modules/nixos/agenix/ryleu`](./modules/nixos/agenix/ryleu)
  (`secureboot-*-key.age`). the public certs and owner GUID are not secret and sit
  next to the module.
- on activation the keys land in `/var/lib/sbctl`, laid out the way `sbctl` expects.
  they are copied rather than symlinked, so the decrypted keys are on disk, root-only.
- the bootloader is installed _before_ agenix decrypts anything. on a machine that
  has never had the keys, `nixos-rebuild switch` fails until a `nixos-rebuild test`
  has put them in place.

### enabling it on a new machine

1. add the machine's host key to `systems` in
   [`secrets.nix`](./modules/nixos/agenix/ryleu/secrets.nix) and run `agenix -r`
   in that directory, from a machine that can already decrypt.
2. import `../secureboot` in the machine's hardware module.
3. put the keys in place, then install the signed bootloader:

   ```sh
   sudo nixos-rebuild test --flake /etc/nixos#<host>
   sudo nixos-rebuild switch --flake /etc/nixos#<host>
   sudo sbctl verify
   ```

4. reboot once with secure boot still off, to check the new bootloader works.
5. put the firmware in setup mode. on a thinkpad: Security -> Secure Boot, enable
   secure boot, then "Reset to Setup Mode". **not** "Clear All Secure Boot Keys",
   which wipes the revocation list.
6. enroll the keys. the microsoft keys stay because bits of the firmware itself are
   signed with them, and leaving them out can brick the machine.

   ```sh
   sudo sbctl enroll-keys --microsoft
   ```

   if it complains that files in efivarfs are immutable, unlock the ones it names
   and run it again:

   ```sh
   sudo nix shell nixpkgs#e2fsprogs -c chattr -i /sys/firmware/efi/efivars/<name>
   ```

7. reboot. `bootctl status` should say `Secure Boot: enabled (user)`.
8. set a firmware supervisor password, or anyone can turn all of this back off.

### unlocking the disk with the tpm

this needs secure boot on first, since turning it on changes PCR 7. the config side
is the systemd initrd plus two crypttab options on the luks device, see
[`ethernet-port`](./modules/hardware/ethernet-port/hardware-configuration.nix):

```nix
boot.initrd.systemd.enable = true;
boot.initrd.luks.devices.<name>.crypttabExtraOpts = [
  "tpm2-device=auto"
  "tpm2-measure-pcr=yes"
];
```

then enroll once. this is what `ethernet-port` uses:

```sh
sudo systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto \
  --tpm2-pcrs=7+15:sha256=0000000000000000000000000000000000000000000000000000000000000000 \
  --tpm2-with-pin=yes \
  /dev/nvme0n1p2
```

- **PCR 7** is the secure boot state and which key verified the boot. booting a usb
  stick or turning secure boot off changes it. rebuilds do not.
- **PCR 15 must be empty**, meaning no volume has been unlocked yet this boot.
  `tpm2-measure-pcr=yes` records each unlocked volume there, which stops someone
  swapping in a fake volume to get their own code running and then asking the tpm
  for the real key. it also means only one volume per boot can unlock this way.
- **the pin** is asked for at every boot.
- the original passphrase is still enrolled as the fallback. if the tpm ever refuses
  (a firmware update can do it), type the passphrase and run the enroll command again.

## general ideas

- i use flakes.
- i have multiple very disperate machines (some graphical, some not).
- it should be intuitive to navigate.
- it should be easy to add more users in the future.
- it should support nix darwin

i execute on very few of these.

