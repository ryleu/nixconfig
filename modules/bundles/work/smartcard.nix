{
  flake.modules.nixos.work =
    { pkgs, ... }:
    {
      services.pcscd.enable = true;
      environment.systemPackages = with pkgs; [
        pcsclite
        pcsc-tools
        opensc
        cacert
      ];
    };
}
