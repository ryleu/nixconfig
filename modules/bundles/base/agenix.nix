# set up encrypted secrets
{ inputs, ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      imports = [
        inputs.agenix.nixosModules.default
      ];

      # make sure we get a host key
      services.openssh.generateHostKeys = true;
      age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

      environment.systemPackages = [
        inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
}
