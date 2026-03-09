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

  # Enable networking
  systemd.network.enable = true;
  networking = {
    networkmanager.enable = false;
    useDHCP = false; # iwd will manage this

    wireless.enable = false; # disable wpa supplicant
    wireless.iwd = {
      enable = true;
      settings = {
        IPv6.Enabled = true;
        Settings = {
          AutoConnect = true;
          ControlPortOverNL80211 = false;
        };
      };
    };

    firewall =
      let
        # open ports for ROS2
        portRanges = [
          {
            from = 7400;
            to = 7999;
          }
        ];
      in
      {
        enable = true;
        allowedTCPPortRanges = portRanges;
        allowedUDPPortRanges = portRanges;
        allowedTCPPorts = [
          25565 # minecraft
        ];
      };
    hostName = pkgs.lib.mkDefault "nixos";

    nameservers = [
      # cloudflare
      "1.1.1.3"
      "1.0.0.3"
      # magicdns for tailscale
      "2606:4700:4700::1113"
      "2606:4700:4700::1003"
    ];
    search = [
      "fawn-stonecat.ts.net"
      "tail08389.ts.net"
    ];
  };

  programs = {
    ssh.startAgent = false;
    gnupg.agent.enable = false;

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

    nh.enable = true;

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    mtr.enable = true;
  };

  services = {
    usbmuxd.enable = true;

    # Enable sound with pipewire.
    pulseaudio.enable = false;

    udev.packages = with pkgs; [
      via
      platformio-core
      openocd
      steam-devices-udev-rules
    ];

    gnome = {
      core-apps.enable = false;
      gnome-keyring.enable = true;
    };

    tailscale.enable = false;

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
        AllowUsers = [
          "ryleu"
          "wyleu"
          "remotebuild"
        ];
        PermitRootLogin = "no";
      };
    };

    xserver.enable = false;

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    desktopManager.gnome.enable = true;

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

    logind.settings.Login = {
      # Suspend instead of powering off when the power button is pressed
      HandlePowerKey = "hibernate";
    };
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
    mutableUsers = false;
    users.ryleu = {
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
      ];
      openssh.authorizedKeys.keyFiles = pkgs.lib.mkDefault [ ];
      shell = pkgs.zsh;
      hashedPassword = "$y$j9T$G2.gK6JpQ18SsfAJ3xe7r0$l37UsbpiRZ7Q1VsYDcfSsAFHy97ZhIWXG7y4t1yRZcA";
    };
    users.wyleu = {
      isNormalUser = true;
      description = "Riley (Work)";
      extraGroups = [
        "wheel"
        "docker"
        "input"
        "kvm"
        "libvirtd"
      ];
      openssh.authorizedKeys.keyFiles = pkgs.lib.mkDefault [ ];
      shell = pkgs.zsh;
      hashedPassword = "$y$j9T$zyMzCj7.LtjPiuCS5.XQK.$oGM3MZxbn99H0xWx7mdBcAX.RqiDS5FStYMNcCIM0v3";
    };
  };

  nixpkgs = {
    overlays = [
      (final: prev: {
        gnome-keyring = prev.gnome-keyring.overrideAttrs (oldAttrs: {
          mesonFlags = (builtins.filter (flag: flag != "-Dssh-agent=true") oldAttrs.mesonFlags) ++ [
            "-Dssh-agent=false"
          ];
        });
      })
    ];

    # Allow unfree packages
    config.allowUnfree = true;
  };

  environment = {
    pathsToLink = [
      "/share/zsh"
    ];

    # basic stuff to operate the system with. most is in home manager
    systemPackages = with pkgs; [
      libimobiledevice
      ifuse
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
      tree
    ];
  };

  virtualisation = {
    #docker.enable = true;
    libvirtd = {
      enable = true;

      qemu.swtpm.enable = true;

    };
    spiceUSBRedirection.enable = true;
    waydroid.enable = true;
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

    optimise.automatic = true;

    distributedBuilds = true;
    settings.builders-use-substitutes = true;
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
