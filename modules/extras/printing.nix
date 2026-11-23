# Enable CUPS to print documents.
{
  flake.modules.nixos.printing =
    { pkgs, ... }:
    {
      services.printing = {
        enable = true;
        browsed.enable = false;
      };

      # i hate printers so much. sane is the worst misnomer for anything printer-related that i have ever seen in my entire life.
      #  please send help.
      hardware.sane = {
        enable = true;
        extraBackends = [ pkgs.sane-airscan ];
      };
    };
}
