# the ssh client: one agent per user and the settings every host entry
# shares. each user's own host entries are in modules/users/<name>/keys.nix
{
  flake.modules.homeManager.base = {
    # the user-level agent, not programs.ssh.startAgent: this one also puts
    # SSH_AUTH_SOCK into the systemd user environment, so graphical apps see
    # the agent and not just shells
    services.ssh-agent.enable = true;

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      extraConfig = ''
        PreferredAuthentications publickey,password
        IdentitiesOnly true
        IdentityFile ~/.ssh/id_ed25519
      '';
      settings."*" = {
        AddKeysToAgent = "yes";
        ForwardAgent = true;
        Compression = true;
      };
    };
  };
}
