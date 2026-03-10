{ ... }:
{
  programs = {
    git = {
      enable = true;
      settings.init.defaultBranch = "main";
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
    };
  };
}
