{ ... }:
{
  programs = {
    git = {
      enable = true;
      settings = {
        commit.gpgsign = true;
        gpg.format = "ssh";
        user = {
          signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID3ETWWGQPgH2cNSFvdyo6/kA9Xni/cebIEz8mXqqzYD";
          email = "riley.mclain@watts.ai";
          name = "riley.mclain";
        };
        init.defaultBranch = "main";
      };
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
    };
  };
}
