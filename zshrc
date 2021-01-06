# vim: ft=zsh

if [[ -d "$HOME/.zfunctions" ]]; then
  fpath=( "$HOME/.zfunctions" $fpath )
fi

cf_zsh_modules="$CF_DOTFILES/zsh_modules"
[ -s "$cf_zsh_modules/alias" ] && source "$cf_zsh_modules/alias"
[ -s "$cf_zsh_modules/functions" ] && source "$cf_zsh_modules/functions"
[ -s "$cf_zsh_modules/lazy_nvm" ] && source "$cf_zsh_modules/lazy_nvm"
[ -s "$cf_zsh_modules/fzf" ] && source "$cf_zsh_modules/fzf"
[ -s "$cf_zsh_modules/title" ] && source "$cf_zsh_modules/title"
[ -s "$cf_zsh_modules/vim_mode" ] && source "$cf_zsh_modules/vim_mode"
[ -s "$cf_zsh_modules/history" ] && source "$cf_zsh_modules/history"
[ -s "$cf_zsh_modules/completion" ] && source "$cf_zsh_modules/completion"
[ -s "$cf_zsh_modules/ui" ] && source "$cf_zsh_modules/ui"
