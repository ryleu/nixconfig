{ lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kubernetes-helm
    kubectl
    kind
    tilt
    k9s
    helm-ls
  ];

  networking.firewall.allowedTCPPorts = [
    6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
    # 2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
    # 2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
  ];
  networking.firewall.allowedUDPPorts = [
    # 8472 # k3s, flannel: required if using multi-node for inter-node networking
  ];
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--node-ip=127.0.0.1"
      "--embedded-registry"
    ];
  };

  # enable the embedded distributed registry mirror for all registries
  environment.etc."rancher/k3s/registries.yaml".text = ''
    mirrors:
      "*":
  '';

  # only start k3s when wyleu logs in
  systemd.services.k3s.wantedBy = lib.mkForce [ "wyleu-work.target" ];
  systemd.services.k3s.partOf = [ "wyleu-work.target" ];

  systemd.targets.wyleu-work = {
    description = "Work services for wyleu";
    bindsTo = [ "user@1001.service" ];
    after = [ "user@1001.service" ];
    wantedBy = [ "user@1001.service" ];
  };
}
