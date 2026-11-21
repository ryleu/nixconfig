{
  flake.modules.homeManager.ryleu = {
    imports = [
      (_: {
        programs = {
          git = {
            settings = {
              commit.gpgsign = true;
              gpg.format = "ssh";
              user = {
                signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFeciFh+2gPJVraEZ33Gne4jDQdeYNlG3Q0czt0hVsrv";
                email = "69326171+ryleu@users.noreply.github.com";
                name = "ryleu";
              };
              # fetch github over https, push over ssh
              url."ssh://git@github.com".pushInsteadOf = "https://github.com";
            };
          };
        };
      })
    ];

    home = {
      username = "ryleu";
      homeDirectory = "/home/ryleu";
      stateVersion = "25.11";
    };
  };

  flake.modules.nixos.ryleu =
    { pkgs, ... }:
    {
      users.users.ryleu = {
        isNormalUser = true;
        description = "Riley";
        extraGroups = [
          "wheel"
          "docker"
          "input"
          "kvm"
          "i2c"
          "libvirtd"
          "dialout"
          "video"
          "render"
        ];
        shell = pkgs.zsh;
        hashedPassword = "$y$j9T$zyMzCj7.LtjPiuCS5.XQK.$oGM3MZxbn99H0xWx7mdBcAX.RqiDS5FStYMNcCIM0v3";
      };
    };
}
