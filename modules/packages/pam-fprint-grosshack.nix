# pam module for fprint that doesn't block passwords when waiting for fingerprint scan
{
  perSystem =
    { pkgs, lib, ... }:
    {
      # linux only
      packages = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        pam-fprint-grosshack = pkgs.stdenv.mkDerivation {
          pname = "pam-fprint-grosshack";
          version = "0.3.0-unstable-2022-07-27";

          src = pkgs.fetchFromGitLab {
            owner = "mishakmak";
            repo = "pam-fprint-grosshack";
            rev = "45b42524fb5783e1e555067743d7e0f70d27888a";
            hash = "sha256-obczZbf/oH4xGaVvp3y3ZyDdYhZnxlCWvL0irgEYIi0=";
          };

          buildInputs = with pkgs; [
            pam
            systemd
          ];

          # needs libfprint, polkit and pam_wrapper from
          # the fprintd tree it was forked from to compile
          dontConfigure = true;
          buildPhase = ''
            runHook preBuild
            cat > config.h <<EOF
            #define GETTEXT_PACKAGE "fprintd"
            EOF
            $CC -shared -fPIC -O2 -std=gnu99 -I. \
              -DLOCALEDIR="\"${pkgs.fprintd}/share/locale\"" \
              pam/pam_fprintd.c -o pam_fprintd_grosshack.so \
              -Wl,--version-script,pam/pam_fprintd.ver \
              -lpam -lsystemd -lpthread
            runHook postBuild
          '';
          installPhase = ''
            runHook preInstall
            install -Dm755 -t $out/lib/security pam_fprintd_grosshack.so
            runHook postInstall
          '';

          meta = {
            homepage = "https://gitlab.com/mishakmak/pam-fprint-grosshack";
            license = lib.licenses.gpl2Plus;
            platforms = lib.platforms.linux;
          };
        };
      };
    };
}
