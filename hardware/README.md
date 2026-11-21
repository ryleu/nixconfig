# hardware

my configuration extends beyond just nix stuff and also includes some of the hardware
i use in my day-to-day.

## machines

i own a few different machines, some of which will be present in the nix config at
any moment in time. here's a list:

- `monument`
  - Dell PowerEdge R730
  - this is a server that chills in the basement.
    it operates mostly as a NAS and a minecraft server box.
    i run truenas scale on it, though i want to change it to nixos.
  - the name comes from it being a monumental effort to procure and set up
- `amulet`
  - ROG Ally Z1 Extreme
  - i play video games on this one. it currently runs Bazzite
- `frame`
  - Steam Frame!
  - i use it for beatsaber
- `temple`
  - AMD BC250
  - i play games on it
- [`stela`](../modules/hosts/stela) (formerly `ethernet-port`)
  - Thinkpad P14 Gen 6 AMD

## peripherals

i have some peripherals that come with me in my backpack.

- **keyboard:** i use an afternoon labs breeze with glorious pandas in it.
  it has a columnar stagger, which is more comfortable for me.
  you can find my qmk config [here](./afternoon_labs_breeze.json).
  it can be flahsed with
  `BOOTLOADER=atmel-dfu qmk flash /etc/nixos/hardware/afternoon_labs_breeze.json`    
  as i use an elite c for my board.
- **mouse:** i use a logitech lift for day-to-day use.
  it helps with my hand pain due to repetitive strain injuries.
- **portable monitor:** i got a crummy 1080p portable monitor off of bestbuy that
  works excellently.
  i think the brand is AOC, but it's not stand out enough that i can recommend it.
