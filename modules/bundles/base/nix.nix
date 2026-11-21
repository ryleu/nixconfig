{
  flake.modules.nixos.base = {
    # i like flakes c:
    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [
          "root"
          "ryleu"
          "wyleu"
        ];

        substituters = [ "https://cache.ryleu.me/astra" ];
        trusted-public-keys = [ "astra:d9bYlP7iR2odaZA2hYYuZRfaeN89lK+W1hiw6THibeQ=" ];
      };

      optimise.automatic = true;
    };
  };
}
