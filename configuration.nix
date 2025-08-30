{
  pkgs,
  ...
}:

{
  boot = {
    kernelModules = pkgs.lib.mkDefault [
      "i2c-dev"
      "hid-playstation"
      "hidp"
    ];

    # Bootloader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # secrets
  age.secrets = {
    # when you have secrets, put them here like this
    #   my-secret.file = ./secrets/my-secret.age;
    # they can later be accessed like this
    #   config.age.secrets.my-secret.path
    id_ed25519-key = {
      file = ./secrets/id_ed25519-key.age;
      path = "/home/ryleu/.ssh/id_ed25519";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    redoak-key = {
      file = ./secrets/redoak-key.age;
      path = "/home/ryleu/.ssh/redoak";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    clucky-key = {
      file = ./secrets/clucky-key.age;
      path = "/home/ryleu/.ssh/clucky";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    monument-key = {
      file = ./secrets/monument-key.age;
      path = "/home/ryleu/.ssh/monument";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    proxy-key = {
      file = ./secrets/proxy-key.age;
      path = "/home/ryleu/.ssh/proxy";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    voron-key = {
      file = ./secrets/voron-key.age;
      path = "/home/ryleu/.ssh/voron";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    ripi-key = {
      file = ./secrets/ripi-key.age;
      path = "/home/ryleu/.ssh/ripi";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    github-key = {
      file = ./secrets/github-key.age;
      path = "/home/ryleu/.ssh/github";
      mode = "600";
      owner = "ryleu";
      group = "users";
    };

    remotebuild-key = {
      file = ./secrets/remotebuild-key.age;
      path = "/root/.ssh/remotebuild";
      mode = "600";
      owner = "root";
      group = "root";
    };
  };

  networking = {
    hostName = pkgs.lib.mkDefault "nixos";

    nameservers = [
      # cloudflare
      "1.1.1.3"
      "1.0.0.3"
      "2606:4700:4700::1113"
      "2606:4700:4700::1003"
    ];
    search = [
      "fawn-stonecat.ts.net"
      "tail08389.ts.net"
    ];

    # Enable networking
    networkmanager.enable = pkgs.lib.mkDefault true;

    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  programs = {
    zsh.enable = true;

    dconf.enable = true;

    # enable hyprland
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    hyprlock.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = pkgs.lib.mkDefault false;
      dedicatedServer.openFirewall = pkgs.lib.mkDefault false;
      package = pkgs.steam.override {
        extraPkgs =
          pkgs: with pkgs; [
            libkrb5
            keyutils
            gamescope
          ];
      };
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services = {
    # Enable sound with pipewire.
    pulseaudio.enable = false;

    udev.packages = with pkgs; [ via ];

    hardware = {
      openrgb = {
        enable = true;
        package = pkgs.openrgb-with-all-plugins;
      };
    };

    gnome = {
      core-apps.enable = false;
      gnome-keyring.enable = true;
    };

    tailscale.enable = true;

    blueman.enable = true;

    fail2ban = {
      enable = true;
      # Ban IP after 5 failures
      maxretry = 5;
      ignoreIP = [
        "100.109.0.71/32"
      ];
      bantime = "24h"; # Ban IPs for one day on the first ban
      bantime-increment = {
        enable = true; # Enable increment of bantime after each violation
        formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
        maxtime = "168h"; # Do not ban for more than 1 week
        overalljails = true; # Calculate the bantime based on all the violations
      };
    };

    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = false;
        AllowUsers = [ "ryleu" "remotebuild" ];
        PermitRootLogin = "no";
      };
    };

    xserver = {
      enable = false;

      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };

      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      desktopManager.gnome.enable = true;
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    logind.extraConfig = ''
      # suspend instead of powering off when the power button is pressed
      HandlePowerKey=suspend
    '';
  };

  hardware = {
    keyboard.qmk.enable = true;

    i2c.enable = true;

    # enable bluetooth
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          ControllerMode = "dual";
          Experimental = true;
        };
      };
    };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.hyprlock = { };
  };

  # Define a user account.
  users = {
    users.ryleu = {
      isNormalUser = true;
      description = "Riley";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "input"
        "kvm"
        "i2c"
        "libvirtd"
        "plugdev"
      ];
      openssh.authorizedKeys.keyFiles = pkgs.lib.mkDefault [ ];
      shell = pkgs.zsh;
      # todo: use a password file with agenix
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment = {
    pathsToLink = [
      "/share/zsh"
    ];

    # basic stuff to operate the system with. most is in home manager
    systemPackages = with pkgs; [
      gnomeExtensions.blur-my-shell
      seahorse
      gnome-keyring
      gnome-boxes
      dnsmasq
      phodav
      nautilus
      usbutils
      docker-buildx
      vim
      wget
      git
      qmk
      via
    ];
  };

  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;

      qemu = {
        swtpm.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };

    };
    spiceUSBRedirection.enable = true;
  };

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
        "remotebuild"
      ];

    };
  };

  system = {
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "24.11"; # Did you read the comment?
  };
}
