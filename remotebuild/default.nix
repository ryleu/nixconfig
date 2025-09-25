{ pkgs, ... }:
{
  users.groups.remotebuild = { };
  users.users.remotebuild = {
    isNormalUser = true;
    createHome = true;
    home = "/opt/remotebuild";
    group = "remotebuild";

    openssh.authorizedKeys.keyFiles = [ ./remotebuild.pub ];
  };

  nix = {
    #distributedBuilds = true;
    #settings.builders-use-substitutes = true;

    buildMachines = [
      {
        hostName = "rectangle";
        sshUser = "remotebuild";
        sshKey = "/root/.ssh/remotebuild";
        protocol = "ssh";
        system = pkgs.stdenv.hostPlatform.system;
        supportedFeatures = [
          "nixos-test"
          "big-parallel"
          "kvm"
        ];
      }
    ];
  };
}
