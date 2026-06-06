{
  flake.modules.nixos.server = {
    programs.steam = {
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}
