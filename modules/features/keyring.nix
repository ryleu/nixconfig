{
  flake.modules.nixos.gui =
    { pkgs, ... }:
    {
      services.gnome = {
        gnome-keyring.enable = true;
        gcr-ssh-agent.enable = false;
      };

      environment.systemPackages = with pkgs; [
        seahorse
        gnome-keyring
      ];
    };

  flake.modules.homeManager.gui.services.gnome-keyring = {
    enable = true;
    components = [ "secrets" ];
  };
}
