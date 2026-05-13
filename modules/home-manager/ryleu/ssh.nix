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
    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
        forwardAgent = true;
        compression = true;
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/github";
        identitiesOnly = true;
      };

      "ripi" = {
        hostname = "ripi";
        user = "ryleu";
        identityFile = "~/.ssh/ripi";
        identitiesOnly = true;
      };

      "redoak" = {
        hostname = "100.65.152.98";
        user = "willow";
        identityFile = "~/.ssh/redoak";
        identitiesOnly = false;
      };

      "proxy" = {
        hostname = "proxy";
        user = "ryleu";
        identityFile = "~/.ssh/proxy";
        identitiesOnly = true;
      };

      "monument.lan" = {
        hostname = "192.168.1.210";
        user = "truenas_admin";
        identityFile = "~/.ssh/monument";
        identitiesOnly = true;
      };

      "clucky" = {
        hostname = "192.168.1.69";
        user = "clucky";
      };

      "spotipi" = {
        hostname = "spotipi";
        user = "ryleu";
        identityFile = "~/.ssh/github";
        identitiesOnly = true;
      };

      "rectangle" = {
        hostname = "rectangle";
        user = "ryleu";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
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
