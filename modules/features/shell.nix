{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        historySubstringSearch.enable = true;

        completionInit = ''
          zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        '';

        oh-my-zsh.plugins = [ pkgs.zsh-nix-shell ];

        shellAliases = {
          la = "ls -alh";
          ":q" = "exit";
          icat = "kitty +kitten icat";
        };

        initContent = ''
          export RY_NOTES_DIR="$HOME/Documents/Notes"
          export RY_TODO_PATH="$HOME/Documents/todo.md"

          alias todo="vim $RY_TODO_PATH"
          function note {
            mkdir -p "$RY_NOTES_DIR"
            header="Note $(date -I)"
            file="$RY_NOTES_DIR/$header.md"

            if [[ ! -f "$file" ]]
            then
            	vim "$file" +"0read !echo \"\# $header\""
            else
            	vim "$file"
            fi
          }

          function notes {
            vim "$RY_NOTES_DIR"
          }

          function rmnote {
            rm -i "$RY_NOTES_DIR/Note $(date -I).md"
          }

          # fn to restart hyprlock if it crashes
          function restart-hyprlock {
            if [[ ! -z $1 ]]; then
              inst=$1
            else
              inst=0
            fi

            hyprctl --instance $inst eval 'hl.config({ misc = { allow_session_lock_restore = true } })'
            hyprctl --instance $inst dispatch 'hl.dsp.exec_cmd("hyprlock --immediate-render --no-fade-in")'
          }

          # apply ssh alias only if we are using kitty
          [[ "$TERM" = "xterm-kitty" ]] && alias ssh="kitten ssh"


          # keybinds for zsh history substring search
          bindkey "$terminfo[kcuu1]" history-substring-search-up
          bindkey "$terminfo[kcud1]" history-substring-search-down
        '';
      };

      home.sessionVariables = {
        HYPHEN_INSENSITIVE = "true";
        PAGER = "${pkgs.less}/bin/less --mouse";
      };

      programs.starship = {
        enable = true;
        enableZshIntegration = true;
      };

      programs.eza = {
        enable = true;
        enableZshIntegration = true;
        colors = "auto";
        icons = "auto";
      };

      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
      xdg.configFile."direnv/direnv.toml".text = ''
        # https://esham.io/2023/10/direnv
        [global]
        log_format = "[2mdirenv: %s[0m"
        hide_env_diff = true
      '';

      programs.zoxide.enable = true;
      programs.pay-respects.enable = true;
    };
}
