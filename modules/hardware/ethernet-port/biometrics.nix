{
  config,
  lib,
  pkgs,
  ...
}:
let
  # don't block passwords when waiting for a fingerpint
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

    # upstream's meson.build still wants libfprint, polkit and pam_wrapper from
    # the fprintd tree it was forked from
    dontConfigure = true;
    buildPhase = ''
      runHook preBuild
      cat > config.h <<EOF
      #define GETTEXT_PACKAGE "fprintd"
      EOF
      $CC -shared -fPIC -O2 -std=gnu99 -I. \
        -DLOCALEDIR="\"${config.services.fprintd.package}/share/locale\"" \
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

  # the ir camera
  irCamera = "/dev/v4l/by-path/pci-0000:c4:00.4-usb-0:1:1.2-video-index0";

  fingerprintOrPassword = service: {
    order = config.security.pam.services.${service}.rules.auth.unix.order - 10;
    control = "sufficient";
    modulePath = "${pam-fprint-grosshack}/lib/security/pam_fprintd_grosshack.so";
  };

  # lets the browser extension reach the desktop app for biometrics
  bitwardenNativeMessagingHost =
    pkgs.writeTextDir "lib/mozilla/native-messaging-hosts/com.8bit.bitwarden.json"
      (
        builtins.toJSON {
          name = "com.8bit.bitwarden";
          description = "Bitwarden desktop <-> browser bridge";
          path = "${pkgs.bitwarden-desktop}/libexec/desktop_proxy";
          type = "stdio";
          allowed_extensions = [ "{446900e4-71c2-419f-a6a7-df9c091e268b}" ];
        }
      );
in
{
  # different configs for each different type of auth
  options.security.pam.services = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        config.fprintAuth = lib.mkDefault false;
      }
    );
  };

  config = {
    # fingerprint scanner (synaptics 06cb:00f9)
    services.fprintd.enable = true;

    # face recognition
    services.howdy = {
      enable = true;
      control = "sufficient";
      settings.video = {
        device_path = irCamera;
        # ~88% for lit & 100% for dark, so 97 should be fine
        dark_threshold = 97;
      };
    };

    security.pam = {
      # only want enabled for bitwarden & unlock after login
      howdy.enable = false;

      services = {
        # fingerprint or password, whichever comes first
        sudo.rules.auth.fprintd-grosshack = fingerprintOrPassword "sudo";

        # polkit is what bitwarden's "unlock with system authentication" (and
        # so passkey user verification) goes through. face first, then
        # fingerprint or password
        polkit-1 = {
          howdy.enable = true;
          rules.auth.fprintd-grosshack = fingerprintOrPassword "polkit-1";
        };

        hyprlock = {
          howdy.enable = true;
          rules.auth.howdy.order = lib.mkForce (
            config.security.pam.services.hyprlock.rules.auth.unix.order + 10
          );
        };
      };
    };

    # let polkit access the ir camera
    systemd.services."polkit-agent-helper@".serviceConfig = {
      PrivateDevices = false;
      DeviceAllow = [ "char-video4linux rw" ];
    };

    # system wide so polkit can see the com.bitwarden.Bitwarden.unlock action
    environment.systemPackages = [ pkgs.bitwarden-desktop ];

    home-manager.sharedModules = [
      {
        programs.hyprlock.settings.auth.fingerprint.enabled = true;
        programs.zen-browser.nativeMessagingHosts = [ bitwardenNativeMessagingHost ];

        # autostart the desktop app
        systemd.user.services.bitwarden = {
          Unit = {
            Description = "Bitwarden desktop, hidden in the background";
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };
          Service = {
            ExecStart = "${pkgs.bitwarden-desktop}/bin/bitwarden --autostart";
            Restart = "on-failure";
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };
      }
    ];
  };
}
