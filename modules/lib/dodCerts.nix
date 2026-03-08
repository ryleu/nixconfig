pkgs:
let
  dodCerts = pkgs.fetchzip {
    url = "https://militarycac.com/maccerts/AllCerts.zip";
    sha256 = "14zxx2cpjzfjhfzx699vn9i2wi2wsi1d5768n9gvqxl3fpipivvf";
    stripRoot = false;
  };

  grep = "${pkgs.gnugrep}/bin/grep";
  openssl = "${pkgs.openssl}/bin/openssl";
in

pkgs.runCommandLocal "dod-certs" { buildInputs = [ pkgs.openssl ]; } ''
  for cert in ${dodCerts}/*.cer; do
    if ${grep} -q "BEGIN CERTIFICATE" "$cert" 2>/dev/null; then
      cat "$cert"
    else
      ${openssl} x509 -inform DER -in "$cert" -outform PEM 2>/dev/null
    fi
  done > $out
''
