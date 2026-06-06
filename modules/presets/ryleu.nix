{
  flake.modules.nixos.ryleu =
    { lib, pkgs, ... }:
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
        ];
        openssh.authorizedKeys.keyFiles = lib.mkDefault [ ];
        shell = pkgs.zsh;
        hashedPassword = "$y$j9T$G2.gK6JpQ18SsfAJ3xe7r0$l37UsbpiRZ7Q1VsYDcfSsAFHy97ZhIWXG7y4t1yRZcA";
      };

      age.secrets = {
        id_ed25519-key-ryleu = {
          file = ../secrets/ryleu/id_ed25519-key.age;
          path = "/home/ryleu/.ssh/id_ed25519";
          mode = "600";
          owner = "ryleu";
          group = "users";
        };
        redoak-key-ryleu = {
          file = ../secrets/ryleu/redoak-key.age;
          path = "/home/ryleu/.ssh/redoak";
          mode = "600";
          owner = "ryleu";
          group = "users";
        };
        monument-key-ryleu = {
          file = ../secrets/ryleu/monument-key.age;
          path = "/home/ryleu/.ssh/monument";
          mode = "600";
          owner = "ryleu";
          group = "users";
        };
        proxy-key-ryleu = {
          file = ../secrets/ryleu/proxy-key.age;
          path = "/home/ryleu/.ssh/proxy";
          mode = "600";
          owner = "ryleu";
          group = "users";
        };
        ripi-key-ryleu = {
          file = ../secrets/ryleu/ripi-key.age;
          path = "/home/ryleu/.ssh/ripi";
          mode = "600";
          owner = "ryleu";
          group = "users";
        };
        github-key-ryleu = {
          file = ../secrets/ryleu/github-key.age;
          path = "/home/ryleu/.ssh/github";
          mode = "600";
          owner = "ryleu";
          group = "users";
        };
        cosign-key-ryleu = {
          file = ../secrets/ryleu/cosign-key.age;
          path = "/home/ryleu/.cosign/cosign.key";
          mode = "600";
          owner = "ryleu";
          group = "users";
        };
        syncthing-password-ryleu = {
          file = ../secrets/ryleu/syncthing-password.age;
          mode = "600";
          owner = "ryleu";
          group = "users";
        };
      };
    };

  flake.modules.homeManager.ryleu =
    { pkgs, ... }:
    {
      home = {
        username = "ryleu";
        homeDirectory = "/home/ryleu";
        stateVersion = "25.11";

        packages = with pkgs; [
          # comms
          signal-desktop
          vesktop
          teamspeak6-client

          # 3D print slicers
          prusa-slicer
          orca-slicer
          bambu-studio

          # utilities
          qbittorrent
          hugin # panoramas for URC
          kicad # pcb viewing

          # media
          picard # music metadata
          audacity # music editing

          # cli
          yt-dlp
          packwiz
          blahaj
          whipper
          bun
          xwayland-satellite
        ];
      };

      # git identity
      programs.git.settings = {
        commit.gpgsign = true;
        gpg.format = "ssh";
        user = {
          signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFeciFh+2gPJVraEZ33Gne4jDQdeYNlG3Q0czt0hVsrv";
          email = "69326171+ryleu@users.noreply.github.com";
          name = "ryleu";
        };
      };

      # ssh hosts
      programs.ssh.settings = {
        "github.com" = {
          HostName = "github.com";
          User = "git";
          IdentityFile = "~/.ssh/github";
          IdentitiesOnly = true;
        };
        "ripi" = {
          HostName = "ripi";
          User = "ryleu";
          IdentityFile = "~/.ssh/ripi";
          IdentitiesOnly = true;
        };
        "redoak" = {
          HostName = "100.65.152.98";
          User = "willow";
          IdentityFile = "~/.ssh/redoak";
          IdentitiesOnly = false;
        };
        "proxy" = {
          HostName = "proxy";
          User = "ryleu";
          IdentityFile = "~/.ssh/proxy";
          IdentitiesOnly = true;
        };
        "monument.lan" = {
          HostName = "192.168.1.210";
          User = "truenas_admin";
          IdentityFile = "~/.ssh/monument";
          IdentitiesOnly = true;
        };
        "clucky" = {
          HostName = "192.168.1.69";
          User = "clucky";
        };
        "spotipi" = {
          HostName = "spotipi";
          User = "ryleu";
          IdentityFile = "~/.ssh/github";
          IdentitiesOnly = true;
        };
        "rectangle" = {
          HostName = "rectangle";
          User = "ryleu";
          IdentityFile = "~/.ssh/id_ed25519";
          IdentitiesOnly = true;
        };
      };
    };
}
