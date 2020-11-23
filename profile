# vim: ft=sh

# These must always be present for .dotfiles to work properly
export CF_DOTFILES="${HOME}/.dotfiles"
export CF_SCRIPTS="${CF_DOTFILES}/scripts"
export CF_SCRIPTS_LOCAL="${CF_DOTFILES}/local/scripts"
export CF_BUILD="${HOME}/.build"

# XDG
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"

# Default apps
if [ -x "$(command -v nvim)" ]; then
  export EDITOR=nvim
  export VISUAL=nvim
else
  export EDITOR=vim
  export VISUAL=vim
fi
export TERMINAL=xfce4-terminal
export BROWSER=chromium
export READER=zathura
export PAGER=less

# Settings
export CF_LAZY_LOAD_NVM=1

# Neo(vim)
export VIM_FONT="Hack\ 14"
export VIM_PLUGINS=1
export VIM_CTLP_CACHE=1
export NVIM_FONT="Hack 14"
export NVIM_PLUGINS=1
export NVIM_CTLP_CACHE=1

# Path
PATH=$HOME/.local/bin:$CF_SCRIPTS:$CF_SCRIPTS_LOCAL:$PATH
export PATH

# Language
[[ -z "$LANG" ]] && export LANG='en_US.UTF-8'

# Local settings
[ -s "${HOME}/.profile.local" ] && source "${HOME}/.profile.local"
