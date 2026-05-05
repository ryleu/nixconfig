{ lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kubernetes-helm
    kubectl
    kind
    tilt
    k9s
  ];

  networking.firewall.allowedTCPPorts = [
    6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
    # 2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
    # 2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
  ];
  networking.firewall.allowedUDPPorts = [
    # 8472 # k3s, flannel: required if using multi-node for inter-node networking
  ];
  services.k3s.enable = true;
  services.k3s.role = "server";
  services.k3s.extraFlags = toString [
    # "--debug" # Optionally add additional args to k3s
  ];

  # local docker registry
  services.dockerRegistry = {
    enable = true;
    port = 5000;
    listenAddress = "127.0.0.1";
  };

  # tell k3s to pull from it
  environment.etc."rancher/k3s/registries.yaml".text = ''
    mirrors:
      "localhost:5000":
        endpoint:
          - "http://localhost:5000"
  '';

  # only start k3s and docker registry when wyleu logs in
  systemd.services.k3s.wantedBy = lib.mkForce [ "wyleu-work.target" ];
  systemd.services.k3s.partOf = [ "wyleu-work.target" ];
  systemd.services.docker-registry.wantedBy = lib.mkForce [ "wyleu-work.target" ];
  systemd.services.docker-registry.partOf = [ "wyleu-work.target" ];

  systemd.targets.wyleu-work = {
    description = "Work services for wyleu";
    bindsTo = [ "user@1001.service" ];
    after = [ "user@1001.service" ];
    wantedBy = [ "user@1001.service" ];
  };
}
