{ pkgs, ... }:
{
  security.pki.certificateFiles = import ../lib/dodCerts.nix pkgs;

  environment.systemPackages = with pkgs; [
    omnissa-horizon-client
  ];

  systemd.tmpfiles.rules = [
    "d /usr/lib/omnissa/horizon/pkcs11 0755 root root -"
    "L /usr/lib/omnissa/horizon/pkcs11/libopenscpkcs11.so - - - - ${pkgs.opensc}/lib/opensc-pkcs11.so"
    "L /usr/lib/omnissa/libcrypto.so.3 - - - - ${pkgs.openssl.out}/lib/libcrypto.so.3"
    "L /usr/lib/omnissa/libssl.so.3 - - - - ${pkgs.openssl.out}/lib/libssl.so.3"
  ];

  environment.etc."opensc.conf".text = ''
    app default {
      # Force pcscd to be used and disable the direct connect probe
      # that causes the card-absent false positive
      reader_driver pcsc {
        connect_exclusive = false;
        connect_reset = false;
        disconnect_action = leave;
        transaction_end_action = leave;
        reconnect_action = leave;
        enable_pinpad = false;
      }

      # Force CAC driver since autodetect fails
      card_drivers = cac, cac1, PIV-II, default;
    }
  '';
}
