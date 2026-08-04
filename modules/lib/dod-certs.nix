# DoD CA certificates as a directory of PEM files. Shared by wyleu's browser
# (wyleu/browser.nix) and the system trust store (nixos/work.nix).
{ pkgs }:
let
  dodCerts = pkgs.fetchzip {
    url = "https://militarycac.com/maccerts/AllCerts.zip";
    sha256 = "14zxx2cpjzfjhfzx699vn9i2wi2wsi1d5768n9gvqxl3fpipivvf";
    stripRoot = false;
  };

  grep = "${pkgs.gnugrep}/bin/grep";
  openssl = "${pkgs.openssl}/bin/openssl";
in
pkgs.runCommandLocal "dod-certs-dir" { } ''
  mkdir -p $out
  for cert in ${dodCerts}/*.cer; do
    name=$(basename "$cert" .cer)
    if ${grep} -q "BEGIN CERTIFICATE" "$cert" 2>/dev/null; then
      cp "$cert" "$out/$name.pem"
    else
      ${openssl} x509 -inform DER -in "$cert" -outform PEM 2>/dev/null > "$out/$name.pem"
    fi
  done
''
