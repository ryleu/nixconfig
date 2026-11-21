# the small set of command line tools every machine gets
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        silver-searcher-ng
        zip
        unzip
        dig
        pciutils
        file
      ];

      programs = {
        ripgrep.enable = true;
        jq.enable = true;
        fastfetch.enable = true;
        tmux.enable = true;
        bat.enable = true;
        btop = {
          enable = true;
          package = pkgs.btop-rocm;
        };
      };
    };

  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      # basic stuff to operate the system with. most is in home manager
      environment.systemPackages = with pkgs; [
        usbutils
        vim
        wget
        git
        dos2unix
        tree
      ];

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      programs.mtr.enable = true;
    };
}
