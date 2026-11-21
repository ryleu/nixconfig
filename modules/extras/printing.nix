# Enable CUPS to print documents.
{
  flake.modules.nixos.printing = {
    services.printing.enable = true;
  };
}
