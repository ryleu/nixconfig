{
  flake.modules.nixos.graphical = {
    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      # use the example session manager
      #media-session.enable = true;
    };
  };
}
