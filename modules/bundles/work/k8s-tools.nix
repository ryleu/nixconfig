{
  flake.modules.nixos.work =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        kubernetes-helm
        kubectl
        kind
        tilt
        k9s
      ];
    };
}
