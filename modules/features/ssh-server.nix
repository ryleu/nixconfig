{
  flake.modules.nixos.base = {
    services.openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = false;
        AllowUsers = [
          "ryleu"
          "wyleu"
        ];
        PermitRootLogin = "no";
      };
    };

    # protect ssh against brute force
    services.fail2ban = {
      enable = true;
      maxretry = 5;
      ignoreIP = [
        "100.109.0.71/32"
      ];
      bantime = "24h";
      bantime-increment = {
        enable = true;
        formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
        maxtime = "168h";
        overalljails = true;
      };
    };
  };
}
