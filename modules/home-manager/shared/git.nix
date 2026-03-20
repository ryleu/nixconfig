{ ... }:
{
  programs = {
    git = {
      enable = true;
      settings.init.defaultBranch = "main";
    };

    difftastic = {
      enable = true;
      git = {
        enable = true;
        diffToolMode = true;
      };
    };

    mergiraf.enable = true;
  };
}
