{ lib, pkgs, ... }:
let
  dodCertDir = import ../lib/dod-certs.nix { inherit pkgs; };

  # openssl looks up CAs by hash in /etc/ssl/certs. nixos only ships bundle
  # files there, so add a hash-named copy of each cert like debian does.
  dodCertsHashed = pkgs.runCommand "dod-certs-hashed" { nativeBuildInputs = [ pkgs.openssl ]; } ''
    mkdir -p $out
    for cert in ${dodCertDir}/*.pem; do
      hash=$(openssl x509 -subject_hash -noout -in "$cert")
      i=0
      while [ -e "$out/$hash.$i" ]; do i=$((i + 1)); done
      cp "$cert" "$out/$hash.$i"
    done
  '';
in
{
  # trust the DoD CAs system-wide so the horizon client can verify servers
  security.pki.certificateFiles = map (name: "${dodCertDir}/${name}") (
    builtins.attrNames (builtins.readDir dodCertDir)
  );

  environment.etc =
    lib.mapAttrs' (
      name: _: lib.nameValuePair "ssl/certs/${name}" { source = "${dodCertsHashed}/${name}"; }
    ) (builtins.readDir dodCertsHashed)
    // {
      # tell k3s to pull from the local docker registry
      "rancher/k3s/registries.yaml".text = ''
        mirrors:
          "localhost:5000":
            endpoint:
              - "http://localhost:5000"
      '';
    };

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
    enableGarbageCollect = true;
    garbageCollectDates = "weekly";
  };

  # only start k3s and docker registry when wyleu logs in
  systemd.services.k3s.wantedBy = lib.mkForce [ "wyleu-work.target" ];
  systemd.services.k3s.partOf = [ "wyleu-work.target" ];
  systemd.services.docker-registry.wantedBy = lib.mkForce [ "wyleu-work.target" ];
  systemd.services.docker-registry.partOf = [ "wyleu-work.target" ];

  # publish k3s's kubeconfig to wyleu's ~/.kube/config on every start
  systemd.services.k3s-user-kubeconfig = {
    description = "Publish k3s kubeconfig to wyleu as context k3s-protodocs";
    after = [ "k3s.service" ];
    requires = [ "k3s.service" ];
    partOf = [ "wyleu-work.target" ];
    wantedBy = [ "wyleu-work.target" ];
    path = [
      pkgs.kubectl
      pkgs.coreutils
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      # k3s writes its kubeconfig shortly after the API server is up.
      for _ in $(seq 1 60); do
        [ -f /etc/rancher/k3s/k3s.yaml ] && break
        sleep 1
      done

      tmp=$(mktemp)
      cp /etc/rancher/k3s/k3s.yaml "$tmp"
      chmod 600 "$tmp"
      # k3s names cluster/user/context all "default"; rename the context so it
      # matches the Tiltfile allow-list (also updates current-context).
      KUBECONFIG="$tmp" kubectl config rename-context default k3s-protodocs

      install -d -o wyleu -g users -m 0700 /home/wyleu/.kube
      install -o wyleu -g users -m 0600 "$tmp" /home/wyleu/.kube/config
      rm -f "$tmp"
    '';
  };

  systemd.targets.wyleu-work = {
    description = "Work services for wyleu";
    bindsTo = [ "user@1001.service" ];
    after = [ "user@1001.service" ];
    wantedBy = [ "user@1001.service" ];
  };
}
