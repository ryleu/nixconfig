# governor needed so the gpu can scale down when it's idle
{
  hosts.temple.modules = [
    (
      { pkgs, ... }:
      let
        governor = pkgs.cyan-skillfish-governor-smu;
        config = "/etc/cyan-skillfish-governor-smu/config.toml";
      in
      {
        # lets non-root users talk to it
        services.dbus.packages = [ governor ];

        # symlink over the stock config
        environment.etc."cyan-skillfish-governor-smu/config.toml".source =
          "${governor}/share/cyan-skillfish-governor-smu/default-config.toml";

        # systemd service for when the device is ready
        services.udev.extraRules = ''
          SUBSYSTEM=="drm", KERNEL=="renderD*", ATTRS{vendor}=="0x1002", ATTRS{device}=="0x13fe", TAG+="systemd", ENV{SYSTEMD_ALIAS}+="/dev/cyan_skillfish_gpu"
        '';

        systemd.services.cyan-skillfish-governor-smu = {
          description = "Cyan Skillfish GPU Governor";
          wantedBy = [ "multi-user.target" ];
          # if the gpu driver explodes then this service can stop
          bindsTo = [ "dev-cyan_skillfish_gpu.device" ];
          after = [ "dev-cyan_skillfish_gpu.device" ];
          restartTriggers = [ "${governor}/share/cyan-skillfish-governor-smu/default-config.toml" ];
          serviceConfig = {
            ExecStart = "${governor}/bin/cyan-skillfish-governor-smu ${config}";
            ManagedOOMPreference = "avoid";
            OOMScoreAdjust = -1000;
            Restart = "on-failure";
            RestartSec = 5;
          };
        };
      }
    )
  ];
}
