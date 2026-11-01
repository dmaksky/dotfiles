# Interactive zsh, without a framework.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export EDITOR=nvim
export VISUAL=nvim

# Homebrew can be outside the initial PATH on either macOS architecture.
if [[ $OSTYPE == darwin* ]] && (( ! $+commands[brew] )); then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi
typeset -U path PATH
path=("$HOME/.local/bin" $path)

mkdir -p "$XDG_STATE_HOME/zsh" "$XDG_CACHE_HOME/zsh"
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
setopt inc_append_history hist_ignore_dups hist_save_no_dups hist_reduce_blanks

# Basic auto/tab complete:
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
KEYTIMEOUT=10

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Cursor: block in vi command mode, beam while typing.
_dotfiles_cursor() {
  if [[ $KEYMAP == vicmd ]]; then printf '\e[1 q'; else printf '\e[5 q'; fi
}
zle -N zle-keymap-select _dotfiles_cursor
zle -N zle-line-init _dotfiles_cursor

# Reset the cursor before starting another program.
autoload -Uz add-zsh-hook
_dotfiles_preexec() { printf '\e[5 q'; }
add-zsh-hook preexec _dotfiles_preexec

bindkey -M viins '^[[3~' delete-char
bindkey -M vicmd '^[[3~' vi-delete-char
bindkey -M visual '^[[3~' vi-delete

# Edit the command in Neovim with Ctrl-e.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M viins '^e' edit-command-line
bindkey -M vicmd '^e' edit-command-line

### FZF ###
if (( $+commands[fzf] )); then
  eval "$(fzf --zsh)"
fi

### zoxide ###
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
  alias cd="z"
fi

### Pass (do not move existing stores) ###
if [[ -z $GNUPGHOME && -d $XDG_DATA_HOME/gnupg ]]; then
  export GNUPGHOME="$XDG_DATA_HOME/gnupg"
fi
if [[ -z $PASSWORD_STORE_DIR && -d $XDG_DATA_HOME/pass ]]; then
  export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
fi

### Prompt ###
if (( $+commands[starship] )); then
  export STARSHIP_CONFIG="${STARSHIP_CONFIG:-$XDG_CONFIG_HOME/starship.toml}"
  eval "$(starship init zsh)"
else
  PROMPT='%~ %# '
fi
