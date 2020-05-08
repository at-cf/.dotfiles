# .dotfiles

## Install

### Arch Linux

```sh
git clone -b arch --single-branch --recurse-submodules https://github.com/at-cf/.dotfiles.git
```

Install [Arch](https://gist.github.com/at-cf/dea0e28850f9bc962c8db67a93d241c7) or use [Manjaro](https://manjaro.org/download/). Then see [install.sh](install.sh) for automated install steps.

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

Mostly I use [Visual Studio Code](https://gist.github.com/at-cf/2cad576de9f013c246f09bbae1d7a618) for development now.

## Browser

See [privacytools.io](https://www.privacytools.io/browsers/). Some good [Firefox](https://www.mozilla.org/en-US/firefox/new/) extensions:

- [Decentraleyes](https://addons.mozilla.org/en-US/firefox/addon/decentraleyes/)
- [HTTPS Everywhere](https://addons.mozilla.org/en-US/firefox/addon/https-everywhere/)
- [Privacy Badger](https://addons.mozilla.org/en-US/firefox/addon/privacy-badger17/)
- [uBlock Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/)
- [uMatrix](https://addons.mozilla.org/en-US/firefox/addon/umatrix/) (advanced)
- [Canvas Defender](https://addons.mozilla.org/en-US/firefox/addon/no-canvas-fingerprinting/)
- [Cookie AutoDelete](https://addons.mozilla.org/en-US/firefox/addon/cookie-autodelete/)
- [Smart Referer](https://addons.mozilla.org/en-US/firefox/addon/smart-referer/)
- [Vimium-FF](https://addons.mozilla.org/en-US/firefox/addon/vimium-ff/)
