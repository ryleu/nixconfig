{ ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    extraConfig = ''
      PreferredAuthentications publickey,password
      IdentitiesOnly true
      IdentityFile ~/.ssh/id_ed25519
    '';
    settings = {
      "*" = {
        AddKeysToAgent = "yes";
        ForwardAgent = true;
        Compression = true;
      };

      "gitlab.com" = {
        HostName = "gitlab.com";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = true;
      };
    };
  };

  services = {
    gnome-keyring = {
      enable = true;
      components = [ "secrets" ];
    };

    ssh-agent.enable = true;
  };
}
