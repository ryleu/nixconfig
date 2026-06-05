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
      "github.com" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/github";
        IdentitiesOnly = true;
      };

      "ripi" = {
        HostName = "ripi";
        User = "ryleu";
        IdentityFile = "~/.ssh/ripi";
        IdentitiesOnly = true;
      };

      "redoak" = {
        HostName = "100.65.152.98";
        User = "willow";
        IdentityFile = "~/.ssh/redoak";
        IdentitiesOnly = false;
      };

      "proxy" = {
        HostName = "proxy";
        User = "ryleu";
        IdentityFile = "~/.ssh/proxy";
        IdentitiesOnly = true;
      };

      "monument.lan" = {
        HostName = "192.168.1.210";
        User = "truenas_admin";
        IdentityFile = "~/.ssh/monument";
        IdentitiesOnly = true;
      };

      "clucky" = {
        HostName = "192.168.1.69";
        User = "clucky";
      };

      "spotipi" = {
        HostName = "spotipi";
        User = "ryleu";
        IdentityFile = "~/.ssh/github";
        IdentitiesOnly = true;
      };

      "rectangle" = {
        HostName = "rectangle";
        User = "ryleu";
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
