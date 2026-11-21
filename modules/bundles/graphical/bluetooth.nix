{
  flake.modules.nixos.graphical = {
    hardware.bluetooth = {
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
}
