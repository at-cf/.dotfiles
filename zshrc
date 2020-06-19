# vim: ft=zsh

if [[ -d "$HOME/.zfunctions" ]]; then
  fpath=( "$HOME/.zfunctions" $fpath )
fi

stty -ixon

export TERM="xterm-256color"
{ infocmp -1 xterm-256color ; echo "\tsitm=\\E[3m,\n\tritm=\\E[23m,"; } | tic -x -

cf_zsh_modules="$CF_DOTFILES/zsh_modules"
[ -s "$cf_zsh_modules/alias" ] && source "$cf_zsh_modules/alias"
[ -s "$cf_zsh_modules/functions" ] && source "$cf_zsh_modules/functions"
[ -s "$cf_zsh_modules/lazy_nvm" ] && source "$cf_zsh_modules/lazy_nvm"
[ -s "$cf_zsh_modules/fzf" ] && source "$cf_zsh_modules/fzf"
[ -s "$cf_zsh_modules/title" ] && source "$cf_zsh_modules/title"
[ -s "$cf_zsh_modules/vim_mode" ] && source "$cf_zsh_modules/vim_mode"
if [[ -f "$HOME/.zfunctions/prompt_spaceship_setup" ]]; then
  [ -s "$cf_zsh_modules/spaceship_prompt" ] && source "$cf_zsh_modules/spaceship_prompt"
fi

# History
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=$HISTSIZE
export HISTORY_IGNORE='ls*|l|l *|ll|ll *|cd*|pwd|exit|x|q|clear|c|hg*|h|history|su|~|v|v *|vim*|t'
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
setopt inc_append_history
# setopt share_history

# Completion
zmodload zsh/complist
autoload -Uz compinit && compinit
unsetopt menu_complete
unsetopt flowcontrol
setopt auto_menu
setopt complete_in_word
setopt always_to_end
bindkey -M menuselect '^[[Z' reverse-menu-complete
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# Syntax highlighting
[ -s "${CF_BUILD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] \
  && source "${CF_BUILD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
