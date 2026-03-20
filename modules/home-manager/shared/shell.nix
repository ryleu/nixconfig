{ pkgs, ... }:
{
  # i use zsh
  programs.zsh.enable = true;

  ## AUTOCOMPLETE ##
  programs.zsh = {
    enableCompletion = true;
    autosuggestion.enable = true;
    completionInit = ''
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
    '';
    historySubstringSearch.enable = true;
    oh-my-zsh.plugins = [
      pkgs.zsh-nix-shell
    ];
  };
  home.sessionVariables = {
    HYPHEN_INSENSITIVE = "true";
    PAGER = "${pkgs.less}/bin/less --mouse";
  };

  ## PROMPT ##
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zsh.syntaxHighlighting.enable = true;

  ## ALIASES ##
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    colors = "auto";
    icons = "auto";
  };
  programs.zsh = {
    shellAliases = {
      la = "ls -alh";
      ":q" = "exit";
      icat = "kitty +kitten icat";
    };
  };

  ## CONVENIENCE ##
  programs.pay-respects.enable = true;
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  ## ZSH EXTRAS ##
  programs.zsh.initContent = ''
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

      hyprctl --instance $inst 'keyword misc:allow_session_lock_restore 1'
      hyprctl --instance $inst 'dispatch exec hyprlock'
    }

    # apply ssh alias only if we are using kitty
    [[ "$TERM" = "xterm-kitty" ]] && alias ssh="kitten ssh"


    # keybinds for zsh history substring search
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down
  '';
}
