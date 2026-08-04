{ inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;

  master_pkgs = import inputs.master_pkgs {
    inherit system;
    config.allowUnfree = true;
  };

  openssl30_pkgs = import inputs.openssl30_pkgs { inherit system; };

  # Build opensc against openssl 3.0 so its pkcs11 module matches the openssl
  # the horizon client bundles. The default opensc (openssl 3.6) either fails
  # to load in the client or breaks its TLS handshake.
  opensc-openssl30 = pkgs.opensc.override { openssl = openssl30_pkgs.openssl; };
in
{
  home.packages = with pkgs; [
    # utilities
    dbeaver-bin
    # CAC auth works via opensc pkcs11 + pcscd (enabled in hardware/ethernet-port)
    (omnissa-horizon-client.override { opensc = opensc-openssl30; })

    # cli
    google-cloud-sdk # provides gcloud cli
    glab
    master_pkgs.claude-code
    docker-buildx # better docker builder
    master_pkgs.liteparse
    nodejs_latest
    biome # nodejs toolchain
    libnotify
  ];
}
