{ inputs, ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      imports = [
        inputs.agenix.nixosModules.default
        inputs.nixos-hardware.nixosModules.common-pc-ssd
      ];

      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [
          "root"
          "ryleu"
        ];
      };

      # no imperative users passwd or shadow
      users.mutableUsers = false;

      # programs for a basic linux system
      programs = {
        zsh.enable = true;
        dconf.enable = true;
        mtr.enable = true;
      };

      environment = {
        pathsToLink = [ "/share/zsh" ];
        sessionVariables = {
          GSM_SKIP_SSH_AGENT_WORKAROUND = "1";
          PROTON_ENABLE_WAYLAND = "1";
        };
        systemPackages = [
          inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
        ]
        ++ (with pkgs; [
          vim
          wget
          git
          tree
          usbutils
        ]);
      };

      security = {
        rtkit.enable = true;
        polkit.enable = true;
      };

      system.stateVersion = "24.11";
    };
}
