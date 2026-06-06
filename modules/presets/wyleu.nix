{
  flake.modules.nixos.wyleu =
    { lib, pkgs, ... }:
    {
      users.users.wyleu = {
        isNormalUser = true;
        description = "Riley (Work)";
        extraGroups = [
          "wheel"
          "docker"
          "input"
          "kvm"
          "libvirtd"
        ];
        openssh.authorizedKeys.keyFiles = lib.mkDefault [ ];
        shell = pkgs.zsh;
        hashedPassword = "$y$j9T$zyMzCj7.LtjPiuCS5.XQK.$oGM3MZxbn99H0xWx7mdBcAX.RqiDS5FStYMNcCIM0v3";
      };

      age.secrets.id_ed25519-key-wyleu = {
        file = ../secrets/wyleu/id_ed25519-key.age;
        path = "/home/wyleu/.ssh/id_ed25519";
        mode = "600";
        owner = "wyleu";
        group = "users";
      };

      # work tools
      environment.systemPackages = with pkgs; [
        kubernetes-helm
        kubectl
        kind
        tilt
        k9s
        helm-ls
      ];

      networking.firewall.allowedTCPPorts = [
        6443 # k3s API
      ];

      services.k3s = {
        enable = true;
        role = "server";
        extraFlags = toString [ ];
      };

      services.dockerRegistry = {
        enable = true;
        port = 5000;
        listenAddress = "127.0.0.1";
        enableGarbageCollect = true;
        garbageCollectDates = "weekly";
      };

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
    };

  flake.modules.homeManager.wyleu =
    { lib, pkgs, ... }:
    let
      dodCerts = pkgs.fetchzip {
        url = "https://militarycac.com/maccerts/AllCerts.zip";
        sha256 = "14zxx2cpjzfjhfzx699vn9i2wi2wsi1d5768n9gvqxl3fpipivvf";
        stripRoot = false;
      };

      grep = "${pkgs.gnugrep}/bin/grep";
      openssl = "${pkgs.openssl}/bin/openssl";

      certDir = pkgs.runCommandLocal "dod-certs-dir" { } ''
        mkdir -p $out
        for cert in ${dodCerts}/*.cer; do
          name=$(basename "$cert" .cer)
          if ${grep} -q "BEGIN CERTIFICATE" "$cert" 2>/dev/null; then
            cp "$cert" "$out/$name.pem"
          else
            ${openssl} x509 -inform DER -in "$cert" -outform PEM 2>/dev/null > "$out/$name.pem"
          fi
        done
      '';
      certList = map (name: "${certDir}/${name}") (builtins.attrNames (builtins.readDir certDir));
    in
    {
      home = {
        username = "wyleu";
        homeDirectory = "/home/wyleu";
        stateVersion = "25.11";

        packages = with pkgs; [
          dbeaver-bin
          glab
          pkgs-unstable.claude-code
        ];
      };

      # work git identity
      programs.git.settings = {
        commit.gpgsign = true;
        gpg.format = "ssh";
        user = {
          signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID3ETWWGQPgH2cNSFvdyo6/kA9Xni/cebIEz8mXqqzYD";
          email = "riley.mclain@watts.ai";
          name = "riley.mclain";
        };
        credential.gpgEncryptionKey = "7D8490DACBD93D7F15B808EA3E3DB6CA7E43CF7E";
      };

      # ssh hosts
      programs.ssh.settings."gitlab.com" = {
        HostName = "gitlab.com";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = true;
      };

      # dod cac certs
      programs.zen-browser = {
        policies = {
          SecurityDevices.CAC-Device = "${pkgs.opensc}/lib/opensc-pkcs11.so";
          Certificates.Install = certList;
        };
      };

      # work monitor layout
      wayland.windowManager.hyprland.extraConfig = lib.mkAfter ''
        hl.monitor({ output = "eDP-1", mode = "2880x1800", position = "0x1080", scale = 1.5 })
        hl.monitor({
            output = "desc:Dell Inc. DELL P2722H FRL6293",
            mode = "1920x1080",
            position = "0x0",
            scale = 1,
        })
        hl.monitor({
            output = "desc:Dell Inc. DELL P2722H 6QL6293",
            mode = "1920x1080",
            position = "1920x0",
            scale = 1,
            transform = 3,
        })

        hl.workspace_rule("1", "monitor:eDP-1")
        hl.workspace_rule("6", "monitor:desc:Dell Inc. DELL P2722H FRL6293")
        hl.workspace_rule("11", "monitor:desc:Dell Inc. DELL P2722H 6QL6293")
      '';
    };
}
