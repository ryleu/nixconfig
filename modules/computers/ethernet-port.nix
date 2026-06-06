{ config, lib, ... }:
let
  monitorLua = lib.mkAfter ''
    -- ethernet-port host monitor overrides
    hl.monitor({
        output = "eDP-1",
        mode = "preferred",
        position = "auto",
        scale = 1.5,
        bitdepth = 10,
        cm = "dcip3",
        vrr = 1,
    })
    hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
  '';
in
{
  configurations.nixos.ethernet-port.module = {
    imports =
      (with config.flake.modules.nixos; [
        base
        gui
        amd-graphics
        laptop
        thinkpad-p14s
        ryleu
        wyleu
      ])
      ++ [
        ./_ethernet-port-hardware.nix
      ];

    networking.hostName = "ethernet-port";
    nixpkgs.hostPlatform = "x86_64-linux";

    # don't need networking to boot a laptop
    systemd.network.wait-online.enable = false;

    systemd.network.networks = {
      "10-enp195s0f0-dhcp.network" = {
        matchConfig.Name = "enp195s0f0";
        networkConfig = {
          DHCP = "yes";
          IPv6AcceptRA = true;
        };
        linkConfig.RequiredForOnline = "no";
      };
      "10-wlan0-dhcp.network" = {
        matchConfig.Name = "wlan0";
        networkConfig = {
          DHCP = "yes";
          IPv6AcceptRA = true;
        };
        linkConfig.RequiredForOnline = "no";
      };
    };

    home-manager.users.ryleu = {
      imports = [ config.flake.modules.homeManager.gui ];
      wayland.windowManager.hyprland.extraConfig = monitorLua;
    };
    home-manager.users.wyleu = {
      imports = [ config.flake.modules.homeManager.gui ];
      wayland.windowManager.hyprland.extraConfig = monitorLua;
    };

    # syncthing cert and key
    age.secrets.syncthing-cert-ryleu = {
      file = ../secrets/ryleu/syncthing-cert-ethernet-port.age;
      mode = "600";
      owner = "ryleu";
      group = "users";
    };
    age.secrets.syncthing-key-ryleu = {
      file = ../secrets/ryleu/syncthing-key-ethernet-port.age;
      mode = "600";
      owner = "ryleu";
      group = "users";
    };
  };
}
