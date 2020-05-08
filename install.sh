#! /bin/bash

set -e

FALLBACK_DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
FALLBACK_HOME="$(dirname $FALLBACK_DOTFILES)"

CF_DOTFILES="${CF_DOTFILES:-$FALLBACK_DOTFILES}"
CF_BUILD="${CF_BUILD:-$FALLBACK_HOME/.build}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$FALLBACK_HOME/.config}"

link() {
  if [ -z "$2" ]; then
    >&2 echo "Need to specify link target" && exit 1
  fi
  local source="${CF_DOTFILES}/${1}"
  echo "Linking $source to $2"
  local parent="$(dirname -- "$2")"
  mkdir -p "$parent"
  if [ -d "$source" ]; then
    ln -sfn "$source" "$2"
  elif [ -f "$source" ]; then
    ln -sf "$source" "$2"
  else
    if [ -z "$3" ]; then
      >&2 echo "$source is not valid" && exit 1
    fi
  fi
}

if [ "$1" = "link" ]; then
  [[ $EUID = 0 ]] && >&2 echo "Do not run as root" && exit 1
  link rgignore ${HOME}/.rgignore
  link angular-config.json ${HOME}/.angular-config.json
  link editorconfig ${HOME}/.editorconfig
  link git/gitignore ${HOME}/.gitignore
  link git/gitconfig ${HOME}/.gitconfig
  link fonts/Hack-Regular.ttf ${HOME}/.local/share/fonts/Hack-Regular.ttf
  link neovim/init.vim ${XDG_CONFIG_HOME}/nvim/init.vim
  link neovim/spell/en.utf-8.add ${XDG_CONFIG_HOME}/nvim/spell/en.utf-8.add
  link neovim/CustomSnippets ${XDG_CONFIG_HOME}/nvim/CustomSnippets
  link neovim/init.vim ${HOME}/.vim/vimrc
  link neovim/spell/en.utf-8.add ${HOME}/.vim/spell/en.utf-8.add
  link neovim/CustomSnippets ${HOME}/.vim/CustomSnippets
  link profile ${HOME}/.profile
  link bash_profile ${HOME}/.bash_profile
  link zprofile ${HOME}/.zprofile
  link zshrc ${HOME}/.zshrc
  link tmux.conf ${HOME}/.tmux.conf
  link zathurarc ${XDG_CONFIG_HOME}/zathura/zathurarc
  if [ -f "${HOME}/.xinitrc" ]; then
    >&2 echo ".xinitrc exists..."
  else
    link xinitrc ${HOME}/.xinitrc
  fi
  link xprofile ${HOME}/.xprofile
  link Xmodmap ${HOME}/.Xmodmap
  link xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml \
    ${XDG_CONFIG_HOME}/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
  link xfce4/terminal/terminalrc ${XDG_CONFIG_HOME}/xfce4/terminal/terminalrc
  # More host-specific stuff
  link local/gitconfig ${HOME}/.gitconfig.local optional
  link local/beets ${XDG_CONFIG_HOME}/beets optional
  link local/mimeapps.list ${XDG_CONFIG_HOME}/mimeapps.list optional
  link local/profile ${HOME}/.profile.local optional
  link local/alias ${HOME}/.alias.local optional
  link local/vlc ${XDG_CONFIG_HOME}/vlc optional
  link local/VeraCrypt ${XDG_CONFIG_HOME}/VeraCrypt optional
  link local/qBittorrent ${XDG_CONFIG_HOME}/qBittorrent optional
  link local/keepassxc ${XDG_CONFIG_HOME}/keepassxc optional
  link local/gtk-3.0/bookmarks ${XDG_CONFIG_HOME}/gtk-3.0/bookmarks optional
  link local/autostart/autostart.desktop ${XDG_CONFIG_HOME}/autostart/autostart.desktop optional
  exit 0
fi

if [ "$1" = "disable-core-dump" ]; then
  [[ $EUID > 0 ]] && >&2 echo "Run as root" && exit 1
  file=/etc/sysctl.d/50-coredump.conf
  echo 'kernel.core_pattern=|/bin/false' > $file
  sysctl -p $file
  exit 0
fi

if [ "$1" = "disable-beep" ]; then
  [[ $EUID > 0 ]] && >&2 echo "Run as root" && exit 1
  echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf
  exit 0
fi

if [ "$1" = "pacman" ]; then
  [[ $EUID > 0 ]] && >&2 echo "Run as root" && exit 1
  if [ "$2" = "system" ]; then
    pacman -S --noconfirm \
      "sysstat" \
      "dos2unix" \
      "acpi" \
      "lm_sensors" \
      "htop" \
      "bc" \
      "pacman-contrib"
    exit 0
  elif [ "$2" = "x" ]; then
    pacman -S --noconfirm \
      "xorg-server" \
      "xorg-xinit" \
      "xorg-xprop" \
      "xorg-xrandr" \
      "xorg-xinput" \
      "xorg-xmodmap" \
      "xorg-xset" \
      "xorg-xbacklight" \
      "xorg-xsetroot" \
      "xclip" \
      "xautolock" \
      "xsel"
    exit 0
  elif [ "$2" = "shell" ]; then
    pacman -S --noconfirm \
      "zsh" \
      "zsh-completions" \
      "tmux" \
      "fzf"
    exit 0
  elif [ "$2" = "security" ]; then
    pacman -S --noconfirm \
      "keepassxc" \
      "veracrypt"
    exit 0
  elif [ "$2" = "sound" ]; then
    pacman -S --noconfirm \
      "pulseaudio" \
      "pavucontrol" \
      "paprefs"
    exit 0
  elif [ "$2" = "network" ]; then
    pacman -S --noconfirm \
      "openssh" \
      "openvpn" \
      "networkmanager" \
      "nm-connection-editor" \
      "networkmanager-openvpn"
    exit 0
  elif [ "$2" = "ufw" ]; then
    pacman -S --noconfirm "ufw" "gufw"
    systemctl enable ufw.service
    systemctl start ufw.service
    ufw enable
    ufw logging off
    exit 0
  elif [ "$2" = "internet" ]; then
    pacman -S --noconfirm \
      "wget" \
      "curl" \
      "firefox" \
      "chromium" \
      "surfraw" \
      "qbittorrent"
      # "uget"
    exit 0
  elif [ "$2" = "virtualbox" ]; then
    pacman -S --noconfirm \
      "virtualbox" \
      "virtualbox-host-modules-arch" \
      "virtualbox-guest-iso"
      # virtualbox-ext-oracle
    echo "Reboot required..."
    # usermod -a -G vboxusers $USER
    # /usr/lib/virtualbox/additions/VBoxGuestAdditions.iso
    exit 0
  elif [ "$2" = "development" ]; then
    # Replace with gvim...
    # pacman -R --noconfirm vim
    pacman -S --noconfirm \
      "ripgrep" \
      "gvim" \
      "git" \
      "python" \
      "python-pip"
    exit 0
  elif [ "$2" = "archive" ]; then
    pacman -S --noconfirm \
      "xarchiver" \
      "p7zip" \
      "unzip" \
      "unrar" \
      "xz" \
      "bzip2" \
      "tar" \
      "rsync"
    exit 0
  elif [ "$2" = "xfce" ]; then
    pacman -S --noconfirm \
      "xfce4" \
      "xfce4-battery-plugin" \
      "xfce4-notifyd" \
      "xfce4-taskmanager" \
      "xfce4-whiskermenu-plugin" \
      "xfce4-systemload-plugin" \
      "xfce4-sensors-plugin" \
      "xfce4-weather-plugin" \
      "xfce4-netload-plugin" \
      "xfce4-screensaver" \
      "network-manager-applet" \
      "pasystray" \
      "mousepad"
    exit 0
  elif [ "$2" = "thunar" ]; then
    pacman -S --noconfirm \
      "gvfs" \
      "tumbler" \
      "poppler-glib" \
      "libgsf" \
      "freetype2" \
      "ffmpegthumbnailer" \
      "thunar" \
      "thunar-archive-plugin" \
      "thunar-media-tags-plugin" \
      "trash-cli" \
      "wipe" \
      "exfat-utils"
    exit 0
  elif [ "$2" = "media" ]; then
    pacman -S --noconfirm \
      "feh" \
      "flameshot" \
      "peek" \
      "cmus" \
      "vlc" \
      "beets" \
      "mp3info" \
      "gimp"
    exit 0
  elif [ "$2" = "office" ]; then
    pacman -S --noconfirm \
      "calibre" \
      "zathura" \
      "zathura-pdf-poppler"
      # "libreoffice-still"
    exit 0
  fi
  >&2 echo 'Specify what to install' && exit 1
fi

if [ "$1" = "yay" ]; then
  if [ "$2" = "packages" ]; then
    [[ $EUID = 0 ]] && >&2 echo "Do not run as root" && exit 1
    yay -S --noconfirm "jmtpfs"
    yay -S --noconfirm "visual-studio-code-bin"
    # yay -S --noconfirm "google-drive-ocamlfuse"
    # yay -S --noconfirm "skypeforlinux-stable-bin"
    # yay -S --noconfirm "chromium-widevine"
    exit 0
  else
    [[ $EUID = 0 ]] && >&2 echo "Do not run as root" && exit 1
    install=$CF_BUILD
    echo "Installing in $install"
    if [ -d $install/yay ] || [ -x "$(command -v yay)" ]; then
      >&2 echo 'yay already installed'
    else
      mkdir -p $install
      cd $install
      git clone --depth 1 https://aur.archlinux.org/yay.git
      cd yay
      makepkg -si
    fi
    exit 0
  fi
fi

if [ "$1" = "tpm" ]; then
  [[ $EUID = 0 ]] && >&2 echo "Do not run as root" && exit 1
  install=$HOME/.tmux/plugins/tpm
  echo "Installing in $install"
  if [ ! -d $install ]; then
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$install"
  else
    >&2 echo 'tpm already installed'
  fi
  exit 0
fi

if [ "$1" = "zsh" ]; then
  if [ "$2" = "spaceship-prompt" ]; then
    [[ $EUID = 0 ]] && >&2 echo "Do not run as root" && exit 1
    mkdir -p $CF_BUILD
    install=$CF_BUILD
    echo "Installing in $install/spaceship-prompt"
    if [ -d $install/spaceship-prompt ]; then
      >&2 echo 'spaceship-prompt already installed'
    else
      mkdir -p $install
      cd $install
      git clone --depth 1 https://github.com/denysdovhan/spaceship-prompt.git
      mkdir -p $HOME/.zfunctions
      ln -sf "$install/spaceship-prompt/spaceship.zsh" "$HOME/.zfunctions/prompt_spaceship_setup"
      echo 'Ensure fpath=( "$HOME/.zfunctions" $fpath ) added to .zshrc'
    fi
    exit 0
  elif [ "$2" = "syntax-highlighting" ]; then 
    [[ $EUID = 0 ]] && >&2 echo "Do not run as root" && exit 1
    mkdir -p $CF_BUILD
    install=$CF_BUILD
    # Note that this install path is hardcoded in .../zsh/modules/syntax
    echo "Installing in $install/zsh-syntax-highlighting"
    if [ -d $install/zsh-syntax-highlighting ]; then
      >&2 echo 'zsh-syntax-highlighting already installed'
    else
      mkdir -p $install
      cd $install
      git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git
    fi
    exit 0
  else
    [[ $EUID = 0 ]] && >&2 echo "Do not run as root" && exit 1
    chsh -s /bin/zsh
    exit 0
  fi
fi

if [ "$1" = "node" ]; then
  if [ "$2" = "packages" ] ; then
    [[ $EUID = 0 ]] && >&2 echo "Do not run as root" && exit 1
    # npm outdated -g --depth=0
    # npm update -g
    packages=(
      "npm@latest"
      "editorconfig"
      "prettier"
      "typescript"
      "typescript-language-server"
      # "neovim"
    )
    for i in "${packages[@]}"; do
      npm install -g "$i"
    done
    exit 0
  else
    [[ $EUID = 0 ]] && >&2 echo "Do not run as root" && exit 1
    install=$HOME
    if [ -d $install/.nvm ]; then
      >&2 echo 'nvm already installed'
    else
      mkdir -p $install
      cd $install
      git clone --depth 1 https://github.com/nvm-sh/nvm.git .nvm
      cd $install/.nvm
      git checkout v0.35.3
    fi
    exit 0
  fi
fi

if [ "$1" = "pip" ]; then
  [[ $EUID = 0 ]] && >&2 echo "Do not run as root" && exit 1
  packages3=(
    "proselint"
    # "pynvim"
    "yamllint"
    "awscli"
    # For beets:
    "pylast"
    "beets-follow"
  )
  for i in "${packages3[@]}"; do
    pip install --user --upgrade "$i"
  done
  exit 0
fi

>&2 echo 'Unknown command' && exit 1
