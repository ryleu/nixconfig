{ inputs, ... }:
{
  flake.modules.homeManager.cac-browser =
    { pkgs, ... }:
    let
      certDir = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.dod-certs;

      certList = map (name: "${certDir}/${name}") (builtins.attrNames (builtins.readDir certDir));
    in
    {
      programs.zen-browser = {
        policies = {
          SecurityDevices.CAC-Device = "${pkgs.opensc}/lib/opensc-pkcs11.so";
          Certificates.Install = certList;
        };
      };
    };
}
