{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
      {                                                                                   
        name = "powerlevel10k";                                                           
        src = pkgs.zsh-powerlevel10k;                                                     
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";                         
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

    dotDir = ".config/zsh";

    history = {
      expireDuplicatesFirst = true;
      size = 40000;
      path = "${config.xdg.dataHome}/zsh_history";
    };

    initContent = ''
      source ~/.config/zsh/.p10k.zsh

      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      autoload -U up-line-or-beginning-search
      autoload -U down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search

      # Keybindings
      bindkey -e
      bindkey '^[OA' up-line-or-beginning-search
      bindkey '^[OB' down-line-or-beginning-search
      bindkey '^[w' kill-region

      # C-right / C-left for word skips
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word

      # C-Backspace / C-Delete for word deletions
      bindkey "^H" backward-kill-word

      # Home/End
      bindkey "^[OH" beginning-of-line
      bindkey "^[OF" end-of-line

      # open commands in $EDITOR with C-e
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^e" edit-command-line

      # case insensitive tab completion
      zstyle ':completion:*' completer _complete _ignored _approximate
      zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' menu select search
      zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
      zstyle ':completion:*' verbose true

      # use cache for completions
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
      _comp_options+=(globdots)

      function yy() {
	      local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	      yazi "$@" --cwd-file="$tmp"
	      if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		      cd -- "$cwd"
                      zle reset-prompt
	      fi
	      rm -f -- "$tmp"
      }

      ${lib.optionalString config.services.gpg-agent.enable ''
        gnupg_path=$(ls $XDG_RUNTIME_DIR/gnupg)
        export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gnupg/$gnupg_path/S.gpg-agent.ssh"
      ''}
    '';

    shellAliases =
      {
        grep = "grep --color";
        ip = "ip --color";
        l = "eza -l";
        la = "eza -la";
        md = "mkdir -p";
        ppc = "powerprofilesctl";
        pf = "powerprofilesctl launch -p performance";

        g = "git";
        gs = "git status";
        ga = "git add";
        gaa = "git add --all";
        gc = "git commit";
        gca = "git commit --amend";
        gp = "git push";
        gpl = "git pull";
        gplr = "git pull --rebase";
        gplf = "git push --ff";
        gb = "git branch";
        gco = "git checkout";
        gcb = "git checkout -b";
        gcm = "git checkout main";
        gcp = "git checkout prod";
        gd = "git diff";
        gl = "git log";
        glo = "git log --oneline --decorate";
        glp = "git log --stat --patch";
        glg = "git log --graph --oneline --decorate";
        glga = "git log --graph --oneline --decorate --all";
        gr = "git restore";
        gm = "git merge";
        gma = "git merge --abort";
        gmc = "git merge --continue";
        grs = "git restore --staged";
        grb = "git rebase";
        grbi = "git rebase -i";
        grba = "git rebase --abort";
        grc = "git rebase --continue";
        grst = "git reset";
        grsts = "git reset --soft";
        grsth = "git reset --hard";
        grev = "git revert";
        gst = "git stash";
        gstp = "git stash pop";
        gsw = "git switch";
        gswc = "git switch -c";

        kvim="NVIM_APPNAME=\"nvim-kickstart\" nvim";
      }
      // lib.optionalAttrs (config.programs.bat.enable == true) {cat = "bat";};
    shellGlobalAliases = {eza = "eza --icons --git";};
  };
} 
