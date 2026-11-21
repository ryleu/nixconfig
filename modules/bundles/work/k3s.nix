{
  flake.modules.nixos.work =
    { lib, pkgs, ... }:
    {
      # tell k3s to pull from the local docker registry
      environment.etc."rancher/k3s/registries.yaml".text = ''
        mirrors:
          "localhost:5000":
            endpoint:
              - "http://localhost:5000"
      '';

      networking.firewall.allowedTCPPorts = [
        6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
        # 2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
        # 2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
      ];
      services.k3s = {
        enable = true;
        role = "server";
      };

      systemd.services = {
        # only start k3s when wyleu logs in
        k3s = {
          wantedBy = lib.mkForce [ "wyleu-work.target" ];
          partOf = [ "wyleu-work.target" ];
        };

        # publish k3s's kubeconfig to wyleu's ~/.kube/config on startup
        k3s-user-kubeconfig = {
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
            # wait for k3s to write its config
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
      };
    };
}
