{ inputs, ... }:
{
  flake.modules.nixos.work =
    { lib, pkgs, ... }:
    let
      dodCertDir = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.dod-certs;

      # openssl looks up CAs by hash in /etc/ssl/certs. nixos only ships bundle
      # files there, so add a hash-named copy of each cert like debian does.
      dodCertsHashed = pkgs.runCommand "dod-certs-hashed" { nativeBuildInputs = [ pkgs.openssl ]; } ''
        mkdir -p $out
        for cert in ${dodCertDir}/*.pem; do
          hash=$(openssl x509 -subject_hash -noout -in "$cert")
          i=0
          while [ -e "$out/$hash.$i" ]; do i=$((i + 1)); done
          cp "$cert" "$out/$hash.$i"
        done
      '';
    in
    {
      # trust the DoD CAs system-wide so the horizon client can verify servers
      security.pki.certificateFiles = map (name: "${dodCertDir}/${name}") (
        builtins.attrNames (builtins.readDir dodCertDir)
      );

      environment.etc = lib.mapAttrs' (
        name: _: lib.nameValuePair "ssl/certs/${name}" { source = "${dodCertsHashed}/${name}"; }
      ) (builtins.readDir dodCertsHashed);
    };
}
