# neovim inside browser text boxes
{
  flake.modules.homeManager.dev =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # the browser extension
      programs.zen-browser.profiles.default.extensions.packages = [ pkgs.firefox-addons.firenvim ];

      # the editor plugin and how it behaves in a text box
      programs.neovim = {
        plugins = [ pkgs.vimPlugins.firenvim ];
        initLua = ''
          vim.g.firenvim_config = {
              globalSettings = { alt = "all" };
              localSettings = {
                  [".*"] = {
                      cmdline = "neovim",
                      content = "text",
                      priority = 1,
                      selector = "textarea",
                      takeover = "always"
                  }
              }
          }
        '';
      };

      # register the native messaging host the extension talks to
      home.activation.firenvimInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD ${config.programs.neovim.finalPackage}/bin/nvim --headless "+call firenvim#install(0)" +qa
      '';
    };
}
