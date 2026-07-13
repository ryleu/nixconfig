{ pkgs, lib, ... }:
let
  vimOpts = {
    termguicolors = true;
    autoindent = true;
    cursorline = true;
    number = true;
    wildmode = "longest,list";
    expandtab = true;
    shiftwidth = 4;
    tabstop = 4;
    signcolumn = "auto";
    linebreak = true;
    foldcolumn = "0";
    foldlevel = 99;
    foldlevelstart = 99;
    foldenable = true;
  };

  vimOptAppends = {
    clipboard = "unnamedplus";
  };

  luaValue =
    v:
    if builtins.isBool v then
      lib.boolToString v
    else if builtins.isInt v then
      toString v
    else
      ''"${v}"'';

  optLines = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (k: v: "vim.opt.${k} = ${luaValue v}") vimOpts
  );

  appendLines = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (k: v: "vim.opt.${k}:append(${luaValue v})") vimOptAppends
  );
in
{
  programs = {
    git.settings.core.editor = "nvim";

    neovim = {
      enable = true;
      defaultEditor = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      withRuby = true;
      withPython3 = true;

      plugins = with pkgs.vimPlugins; [
        # web
        coc-html

        # python
        coc-pyright

        # other
        coc-sh
        coc-json
        coc-docker
        coc-git

        nvim-treesitter.withAllGrammars

        nvim-colorizer-lua

        hmts-nvim

        blink-indent
        guess-indent-nvim

        # folds
        nvim-ufo
      ];

      initLua = ''
        ${optLines}
        ${appendLines}

        require'colorizer'.setup({
          user_default_options = {
            names = false,
          }
        })

        require'ufo'.setup({
          provider_selector = function(bufnr, filetype, buftype)
            return { 'treesitter', 'indent' }
          end,
        })
        vim.keymap.set('n', 'zR', require'ufo'.openAllFolds)
        vim.keymap.set('n', 'zM', require'ufo'.closeAllFolds)

        local neo_enabled = true
        vim.keymap.set('n', '<leader>tn', function()
          if neo_enabled then
            vim.cmd('CocCommand document.toggleInlayHint')
            neo_enabled = false
            vim.notify("Neo features OFF")
          else
            vim.cmd('CocEnable')
            vim.cmd('CocCommand document.toggleInlayHint')
            neo_enabled = true
            vim.notify("Neo features ON")
          end
        end, { desc = "Toggle neo features (inlay hints)" })
      '';

      coc = {
        enable = true;
        settings = {
          languageserver = {
            rust = {
              command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
              args = [ ];
              rootPatterns = [
                "*.rs"
              ];
              filetypes = [ "rust" ];
            };

            typst = {
              command = "${pkgs.tinymist}/bin/tinymist";
              args = [ ];
              filetypes = [ "tpy" ];
            };

            nix = {
              command = "${pkgs.nil}/bin/nil";
              args = [ ];
              filetypes = [ "nix" ];
              settings.nil.nix.flake.autoArchive = true;
            };
          };
          coc.preferences.formatOnType = true;
        };
      };
    };
  };
}
