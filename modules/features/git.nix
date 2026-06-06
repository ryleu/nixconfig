{
  # use the user's gpg-agent (HM) instead of the system one
  flake.modules.nixos.base.programs.gnupg.agent.enable = false;

  flake.modules.homeManager.gui =
    { config, pkgs, ... }:
    {
      programs = {
        git = {
          enable = true;
          settings = {
            init.defaultBranch = "main";
            core.editor = "nvim";
            credential = {
              helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
              credentialStore = "gpg";
            };
          };
        };

        difftastic = {
          enable = true;
          git = {
            enable = true;
            diffToolMode = true;
          };
        };

        mergiraf = {
          enable = true;
          enableGitIntegration = true;
        };

        gpg.enable = true;

        password-store = {
          enable = true;
          settings.PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.local/share/pass";
        };
      };

      services.gpg-agent = {
        enable = true;
        defaultCacheTtl = 3600;
        maxCacheTtl = 86400;
        pinentry.package = pkgs.pinentry-curses;
      };
    };
}
