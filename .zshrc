# Environment
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export EDITOR=nvim
export VISUAL=nvim

# Homebrew
if [[ $OSTYPE == darwin* ]] && (( ! $+commands[brew] )); then
  for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [[ -x $brew ]]; then
      eval "$("$brew" shellenv)"
      break
    fi
  done
  unset brew
fi

# PATH
typeset -U path PATH
path=("$HOME/.local/bin" $path)

# Colors
if [[ $OSTYPE == darwin* ]]; then
  alias ls='ls -G'
else
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
fi

export LESS='-R'

# History
mkdir -p "$XDG_STATE_HOME/zsh" "$XDG_CACHE_HOME/zsh"
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

setopt inc_append_history
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt hist_reduce_blanks

# Completion
autoload -Uz compinit
zmodload zsh/complist

zstyle ':completion:*' menu select
if [[ -n ${LS_COLORS:-} ]]; then
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
else
  zstyle ':completion:*' list-colors ''
fi

compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"
_comp_options+=(globdots)

# Vi mode
bindkey -v
KEYTIMEOUT=10

# Completion navigation
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# Editing
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^[[3~' delete-char
bindkey -M vicmd '^[[3~' vi-delete-char
bindkey -M visual '^[[3~' vi-delete

# Cursor shape
_dotfiles_cursor() {
  if [[ $KEYMAP == vicmd ]]; then
    printf '\e[1 q'
  else
    printf '\e[5 q'
  fi
}

zle -N zle-keymap-select _dotfiles_cursor
zle -N zle-line-init _dotfiles_cursor

autoload -Uz add-zsh-hook
_dotfiles_preexec() { printf '\e[5 q'; }
add-zsh-hook preexec _dotfiles_preexec

# Edit command in Neovim
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M viins '^e' edit-command-line
bindkey -M vicmd '^e' edit-command-line

# FZF
if (( $+commands[fzf] )); then
  source <(fzf --zsh)
fi

# Zoxide
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

# Pass / GnuPG
if [[ -z $GNUPGHOME && -d $XDG_DATA_HOME/gnupg ]]; then
  export GNUPGHOME="$XDG_DATA_HOME/gnupg"
fi

if [[ -z $PASSWORD_STORE_DIR && -d $XDG_DATA_HOME/pass ]]; then
  export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
fi

# Starship
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

# Normal TERM env in ssh sessions
ssh() {
  TERM=xterm-256color command ssh "$@"
}

# Mise
eval "$(mise activate zsh)"
