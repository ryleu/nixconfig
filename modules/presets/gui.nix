{
  flake.modules.nixos.gui =
    { pkgs, ... }:
    {
      # display manager + greeter
      services = {
        xserver.enable = false;
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
        gnome.core-apps.enable = false;

        # audio
        pulseaudio.enable = false;
        pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          jack.enable = true;
        };

        printing.enable = true;
        blueman.enable = true;
        usbmuxd.enable = true;
      };

      # bluetooth
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings.General = {
          ControllerMode = "dual";
          Experimental = true;
        };
      };

      # keyboard / serial
      hardware.keyboard.qmk.enable = true;
      hardware.i2c.enable = true;
      services.udev.packages = with pkgs; [
        via
        platformio-core
        openocd
      ];

      # ryleu needs dialout for board access on graphical hosts
      users.users.ryleu.extraGroups = [ "dialout" ];

      # virtualization
      virtualisation = {
        docker.enable = true;
        libvirtd = {
          enable = true;
          qemu.swtpm.enable = true;
        };
        spiceUSBRedirection.enable = true;
      };

      environment.systemPackages = with pkgs; [
        # gnome
        gnomeExtensions.blur-my-shell

        # virtualization
        gnome-boxes
        dnsmasq
        phodav
        docker-buildx

        # ios devices
        libimobiledevice
        ifuse

        # file manager
        nautilus

        # keyboard
        qmk
        via
      ];
    };
}
