# unlock extension thru desktop app via polkit
{
  flake.modules.nixos.bitwarden-bridge =
    { pkgs, ... }:
    {
      # system wide so polkit can see the com.bitwarden.Bitwarden.unlock action
      environment.systemPackages = [ pkgs.bitwarden-desktop ];
    };

  flake.modules.homeManager.bitwarden-bridge =
    { pkgs, ... }:
    let
      # lets the browser extension reach the desktop app for biometrics
      bitwardenNativeMessagingHost =
        pkgs.writeTextDir "lib/mozilla/native-messaging-hosts/com.8bit.bitwarden.json"
          (
            builtins.toJSON {
              name = "com.8bit.bitwarden";
              description = "Bitwarden desktop <-> browser bridge";
              path = "${pkgs.bitwarden-desktop}/libexec/desktop_proxy";
              type = "stdio";
              allowed_extensions = [ "{446900e4-71c2-419f-a6a7-df9c091e268b}" ];
            }
          );
    in
    {
      programs.zen-browser.nativeMessagingHosts = [ bitwardenNativeMessagingHost ];

      # autostart the desktop app
      systemd.user.services.bitwarden = {
        Unit = {
          Description = "Bitwarden desktop, hidden in the background";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.bitwarden-desktop}/bin/bitwarden --autostart";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
