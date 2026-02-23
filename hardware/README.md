# hardware

my configuration extends beyond just nix stuff and also includes some of the hardware
i use in my day-to-day.

## machines

i own a few different machines, some of which will be present in the nix config at
any moment in time. here's a list:

- [`barely-better`](../modules/hardware/barely-better)
  - Acer Aspire A515-43
  - this is the laptop that's getting me through college.
    unfortunately, it is not long for this world.
  - the name comes from the fact that it is marginally better than `mathrock`, the
    previous free laptop i owned and daily drove.
- `monument`
  - Dell PowerEdge R730
  - this is a server that chills in the basement.
    it operates mostly as a NAS and a minecraft server box.
    i run truenas scale on it, though i want to change it to nixos.
  - the name comes from it being a monumental effort to procure and set up
- [`rectangle`](../modules/hardware/rectangle)
  - custom build hodgepodge of hardware
    - AM4 platform, ryzen 5800X
    - rx6700xt
  - mostly use this one for playing games. since getting `decknt`, i rarely use it.
    may repurpose into a nix build server as it's more powerful than `monument`.
  - the name comes from the shape.
- `decknt`
  - ROG Ally Z1 Extreme
  - i play video games on this one. it currently runs a
    [custom fork of bazzite](https://github.com/ryleu/ryzzite).
  - the name comes from a play on the hostname of my brother's handheld.
    in his naming brilliance, he decided that the valve steam deck should simply be
    called `deck`.
    though simple on the surface, the moniker actually harkens back to a time when
    people called things what they were.
    when a pair of scissors was simply "scissors".
    when a blanket was called "Blanket", or perhaps "Blue Blanket" instead of some
    keyword-filled god-forsaken garble of search terms like "Fleece Plush Throw
    Blanket Navy Blue(50 by 60 Inches),Super Soft Fuzzy Cozy Flannel Blanket for
    Couch Sofa.Microfiber Blanket Lightweight".
    it is an omage to what it is: a deck.

    my handheld is not a deck, so i called it `decknt`.
- [`ethernet-port`](../modules/hardware/ethernet-port)
  - Thinkpad P14 Gen 6 AMD
  - this is a new laptop that i'm hoping will last me 10 years or so.
    its purpose is to replace `barely-better` for general computing and writing code.
  - the name comes from the fact that my Thinkpad has an ethernet port, but
    [@iggy-c](https://github.com/iggy-c)'s does not, thus making mine superior.

## peripherals

i consider the monitors, keyboard, and mouse to be a part of rectangle, so i don't
count those ones.
i have other peripherals that come with me in my backpack.

- **keyboard:** i use an afternoon labs breeze with glorious pandas in it.
  it has a columnar stagger, which is more comfortable for me.
  you can find my qmk config [here](./afternoon_labs_breeze.json).
- **mouse:** i use a logitech lift for day-to-day use.
  it helps with my hand pain due to repetitive strain injuries.
- **portable monitor:** i got a crummy 1080p portable monitor off of bestbuy that
  works excellently.
  i think the brand is AOC, but it's not stand out enough that i can recommend it.

