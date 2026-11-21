# fingerprint login that does not block typing a password
{ inputs, ... }:
{
  flake.modules.nixos.fingerprint =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      # don't block passwords when waiting for a fingerprint
      pam-fprint-grosshack = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.pam-fprint-grosshack;

      fingerprintOrPassword = service: {
        order = config.security.pam.services.${service}.rules.auth.unix.order - 10;
        control = "sufficient";
        modulePath = "${pam-fprint-grosshack}/lib/security/pam_fprintd_grosshack.so";
      };
    in
    {
      # override the default for whether fingerprint auth should be enabled
      # don't change the default to fprintd-grosshack because i only want fingerprint for specific things
      options.security.pam.services = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            config.fprintAuth = lib.mkDefault false;
          }
        );
      };

      config = {
        services.fprintd.enable = true;

        security.pam.services = {
          # enable fingerprint for sudo
          sudo.rules.auth.fprintd-grosshack = fingerprintOrPassword "sudo";

          # enable fingerprint for polkit (includes bitwarden)
          polkit-1.rules.auth.fprintd-grosshack = fingerprintOrPassword "polkit-1";
        };
      };
    };

  flake.modules.homeManager.fingerprint = {
    # let hyprlock handle fingerprint on its own
    programs.hyprlock.settings.auth.fingerprint.enabled = true;
  };
}
