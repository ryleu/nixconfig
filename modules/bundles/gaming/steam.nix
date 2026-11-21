{
  flake.modules.nixos.gaming =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = pkgs.lib.mkDefault false;
        extraPackages = with pkgs; [
          libkrb5
          keyutils
        ];
      };

      environment.sessionVariables.PROTON_ENABLE_WAYLAND = "1";
    };
}
