# let services start when wyleu logs in
{
  flake.modules.nixos.work = {
    systemd.targets.wyleu-work = {
      description = "Work services for wyleu";
      bindsTo = [ "user@1001.service" ];
      after = [ "user@1001.service" ];
      wantedBy = [ "user@1001.service" ];
    };
  };
}
