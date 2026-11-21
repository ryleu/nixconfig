{
  flake.modules.nixos.dev =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        gnome-boxes
        dnsmasq
        phodav
      ];

      virtualisation = {
        libvirtd = {
          enable = true;

          qemu.swtpm.enable = true;
        };
        spiceUSBRedirection.enable = true;
      };
    };
}
