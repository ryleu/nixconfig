# keyring and ssh agent
{
  flake.modules.nixos.desktop = {
    services.gnome = {
      gnome-keyring.enable = true;
      # gnome's ssh agent sucks ass and breaks everything
      gcr-ssh-agent.enable = false;
    };

    programs.gnupg.agent.enable = false;

    environment.sessionVariables.GSM_SKIP_SSH_AGENT_WORKAROUND = "1";
  };
}
