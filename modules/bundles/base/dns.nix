{
  flake.modules.nixos.base = {
    networking = {
      nameservers = [
        # cloudflare
        "1.1.1.3"
        "1.0.0.3"
        # magicdns for tailscale
        "2606:4700:4700::1113"
        "2606:4700:4700::1003"
        # opennic
        "147.93.130.20"
        "94.247.43.254"
        "194.36.144.87"
        "195.10.195.195"
        "2605:a140:3015:4386::1"
        "2a00:f826:8:1::254"
        "2a03:4000:4d:c92:88c0:96ff:fec6:b9d"
        "2a00:f826:8:2::195"
      ];
      search = [
        # tailscale again
        "fawn-stonecat.ts.net"
        "tail08389.ts.net"
      ];
    };
  };
}
