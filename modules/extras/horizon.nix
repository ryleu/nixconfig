{ inputs, ... }:
{
  flake.modules.homeManager.horizon =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # CAC auth works via opensc pkcs11 + pcscd (the smartcard feature)
        (omnissa-horizon-client.override {
          opensc = pkgs.opensc.override {
            # need an old openssl though because horizon is trash
            inherit
              (import inputs.openssl30_pkgs {
                system = pkgs.stdenv.hostPlatform.system;
              })
              openssl
              ;
          };
        })
      ];
    };

  # gtk2 is going to be removed, but horizon is a terribly crusty piece of garbage
  flake.modules.nixos.horizon = {
    nixpkgs.config.problems.handlers."gtk+".broken = "warn";
  };
}
