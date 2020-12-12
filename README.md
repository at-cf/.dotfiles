# .dotfiles

Also see [.dotfiles-ssh](https://github.com/at-cf/.dotfiles-ssh)

## Install

### Arch Linux

Install [Arch](https://gist.github.com/at-cf/dea0e28850f9bc962c8db67a93d241c7) or use [Manjaro](https://manjaro.org/download/). Then see [install.sh](install.sh) for automated install steps.

```sh
git clone --recurse-submodules https://github.com/at-cf/.dotfiles.git
```

### Windows

Install to `$env:USERPROFILE\.dotfiles` (a.k.a. `$env:DOTFILES`, this location cannot be changed):

```posh
powershell -nop -c "iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/at-cf/.dotfiles/master/Bootstrap.ps1'))"
```

Run [O&O ShutUp10](https://www.oo-software.com/en/shutup10) regularly on Windows.

## Vim

If on Windows, get vim from [here](https://tuxproject.de/projects/vim/).

- Set `[N]VIM_PLUGINS=<0|1>` to globally enable or disable all the self-installing [vim-plug](https://github.com/junegunn/vim-plug) plugins (disabled by default, just run stock Vim)
- Set `[N]VIM_FONT` to specify the graphical font used
  - E.g. `VIM_FONT=Hack:h14`/`VIM_FONT="Hack\ 14"` for [Hack](https://sourcefoundry.org/hack/) on Windows/Linux
