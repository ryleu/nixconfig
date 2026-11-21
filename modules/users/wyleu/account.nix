{
  flake.modules.homeManager.wyleu = {
    imports = [
      (_: {
        programs.git.settings = {
          commit.gpgsign = true;
          gpg.format = "ssh";
          user = {
            signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID3ETWWGQPgH2cNSFvdyo6/kA9Xni/cebIEz8mXqqzYD";
            email = "riley.mclain@watts.ai";
            name = "riley.mclain";
          };

          credential.gpgEncryptionKey = "7D8490DACBD93D7F15B808EA3E3DB6CA7E43CF7E";
        };
      })
    ];

    home = {
      username = "wyleu";
      homeDirectory = "/home/wyleu";
      stateVersion = "25.11";
    };
  };

  flake.modules.nixos.wyleu =
    { pkgs, ... }:
    {
      users.users.wyleu = {
        isNormalUser = true;
        description = "Riley (Work)";
        extraGroups = [
          "wheel"
          "docker"
          "input"
          "kvm"
          "libvirtd"
        ];
        shell = pkgs.zsh;
        hashedPassword = "$y$j9T$zyMzCj7.LtjPiuCS5.XQK.$oGM3MZxbn99H0xWx7mdBcAX.RqiDS5FStYMNcCIM0v3";
      };
    };
}
