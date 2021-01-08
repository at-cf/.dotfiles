#! /bin/bash

set -e

[[ $EUID = 0 ]] && >&2 echo "Do not run as root" && exit 1

FALLBACK_DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
FALLBACK_HOME="$(dirname $FALLBACK_DOTFILES)"

CF_USER=${USER:-user}
HOME=${HOME:-FALLBACK_HOME}
CF_DOTFILES="${CF_DOTFILES:-$FALLBACK_DOTFILES}"
CF_BUILD="${CF_BUILD:-$HOME/.build}"
mkdir -p $CF_BUILD
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

link() {
  if [ -z "$2" ]; then
    >&2 echo "Need to specify link target" && exit 1
  fi
  local source="${CF_DOTFILES}/${1}"
  echo "Linking $source to $2"
  local parent="$(dirname -- "$2")"
  mkdir -p "$parent"
  if [ -e "$source" ] && [ -d "$2" ] && [ ! -L "$2" ]; then
    local prompt_remove=1
  elif [ -e "$source" ] && [ -f "$2" ] && [ ! -L "$2" ]; then
    local prompt_remove=1
  fi
  if [ "$prompt_remove" == "1" ]; then
    if [ $($FALLBACK_DOTFILES/scripts/ask_yes_or_no "Replace existing $2?") == "yes" ]; then
      rm -rf "$2"
      local do_link=1
    fi
  else
    local do_link=1
  fi
  if [ "$do_link" == "1" ]; then
    if [ -d "$source" ]; then
      ln -sfn "$source" "$2"
    elif [ -f "$source" ]; then
      ln -sf "$source" "$2"
    else
      if [ -z "$3" ]; then
        >&2 echo "$source is not valid" && exit 1
      fi
    fi
  fi
}

if [ "$1" = "link" ]; then
  link rgignore ${HOME}/.rgignore
  link angular-config.json ${HOME}/.angular-config.json
  link editorconfig ${HOME}/.editorconfig
  link git/gitignore ${HOME}/.gitignore
  link git/gitconfig ${HOME}/.gitconfig
  link fonts/Hack-Regular.ttf ${HOME}/.local/share/fonts/Hack-Regular.ttf
  link fonts/FiraCode-Regular.ttf ${HOME}/.local/share/fonts/FiraCode-Regular.ttf
  link JetBrains/ideavimrc ${HOME}/.ideavimrc
  link neovim/init.vim ${XDG_CONFIG_HOME}/nvim/init.vim
  link neovim/spell/en.utf-8.add ${XDG_CONFIG_HOME}/nvim/spell/en.utf-8.add
  link neovim/init.vim ${HOME}/.vim/vimrc
  link neovim/spell/en.utf-8.add ${HOME}/.vim/spell/en.utf-8.add
  link vscode/settings.json ${XDG_CONFIG_HOME}/Code/User/settings.json
  link vscode/keybindings.json ${XDG_CONFIG_HOME}/Code/User/keybindings.json
  link profile ${HOME}/.profile
  link bash_profile ${HOME}/.bash_profile
  link zprofile ${HOME}/.zprofile
  link zshrc ${HOME}/.zshrc
  link tmux.conf ${HOME}/.tmux.conf
  link xinitrc ${HOME}/.xinitrc
  link xprofile ${HOME}/.xprofile optional
  link Xmodmap ${HOME}/.Xmodmap
  link Xresources ${HOME}/.Xresources
  link xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml \
    ${XDG_CONFIG_HOME}/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
  link xfce4/terminal/terminalrc ${XDG_CONFIG_HOME}/xfce4/terminal/terminalrc
  # More host-specific stuff
  link local/gitconfig ${HOME}/.gitconfig.local optional
  link local/beets ${XDG_CONFIG_HOME}/beets optional
  link local/mimeapps.list ${XDG_CONFIG_HOME}/mimeapps.list optional
  link local/profile ${HOME}/.profile.local optional
  link local/xprofile ${HOME}/.xprofile.local optional
  link local/alias ${HOME}/.alias.local optional
  link local/vlc ${XDG_CONFIG_HOME}/vlc optional
  link local/gtk-3.0/bookmarks ${XDG_CONFIG_HOME}/gtk-3.0/bookmarks optional
  link local/face.jpg ${HOME}/.face optional
  link local/autostart/autostart.desktop ${XDG_CONFIG_HOME}/autostart/autostart.desktop optional
  exit 0
fi

if [ "$1" = "system" ]; then
  if [ "$2" = "disable-core-dump" ]; then
    file=/etc/sysctl.d/50-coredump.conf
    echo 'kernel.core_pattern=|/bin/false' | sudo tee $file &&
      sudo sysctl -p $file
    exit 0
  elif [ "$2" = "disable-beep" ]; then
    echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf
    exit 0
  elif [ "$2" = "home-dirs" ]; then
    mkdir -p ${HOME}/GoogleDrive
    mkdir -p ${HOME}/Documents
    mkdir -p ${HOME}/Downloads
    mkdir -p ${HOME}/Development/.tmp
    mkdir -p ${HOME}/Pictures/Screenshots
    mkdir -p ${HOME}/.tmp
    mkdir -p ${HOME}/.build
    mkdir -p ${HOME}/Android
    exit 0
  elif [ "$2" = "swapfile" ]; then
    swap=${3:-/swapfile}
    size=${4:-16G}
    [ -f "$swap" ] && >&2 echo "${swap} already exists" && exit 1
    sudo fallocate -l $size $swap && \
      sudo chmod 600 $swap && \
      sudo mkswap $swap && \
      sudo sysctl -w vm.swappiness=1 && \
      echo "vm.swappiness=1" | sudo tee -a /etc/sysctl.d/99-sysctl.conf && \
      sudo swapon $swap && \
      echo "${swap} none swap defaults 0 0" | sudo tee -a /etc/fstab && \
      echo >&2 "See the comments to enable hibernate!"
    # Find offset with filefrag -v $swap
    # Add 'resume=/dev/mapper/volgroup0-lv_root resume_offset=<your offset>' to /etc/default/grub and regenerate
    # Change hooks in /etc/mkinitcpio.conf: move keyboard before encrypt, move resume after encrypt/lvm2, before filesystems and then regenerate
    exit 0
  fi
fi

if [ "$1" = "hp" ]; then
  if [ "$2" = "wifi" ]; then
    sudo pacman -S --noconfirm "bc" "dkms" && \
      install=$CF_BUILD && mkdir -p $install && cd $install && \
      git clone --depth 1 https://github.com/tomaspinho/rtl8821ce.git && cd rtl8821ce && \
      sudo ./dkms-install.sh
    exit 0
  fi
fi

if [ "$1" = "pacman" ]; then
  if [ "$2" = "system" ]; then
    sudo pacman -S --noconfirm \
      "base-devel" \
      "sysstat" \
      "dos2unix" \
      "acpi" \
      "lm_sensors" \
      "htop" \
      "bc" \
      "wmctrl"
    # yay -S --noconfirm "cpupower-gui"
    sudo pacman -S --noconfirm "thermald" && \
      sudo systemctl start thermald.service
    exit 0
  elif [ "$2" = "x" ]; then
    sudo pacman -S --noconfirm \
      "xorg-server" \
      "xorg-xinit" \
      "xorg-xinput" \
      "xorg-xprop" \
      "xorg-xrandr" \
      "xorg-xinput" \
      "xorg-xmodmap" \
      "xorg-xset" \
      "xorg-xbacklight" \
      "xorg-xsetroot" \
      "xautolock" \
      "xclip" \
      "xsel"
    exit 0
  elif [ "$2" = "shell" ]; then
    sudo pacman -S --noconfirm \
      "zsh" \
      "zsh-completions" \
      "tmux" \
      "xclip" \
      "fzf"
    exit 0
  elif [ "$2" = "security" ]; then
    sudo pacman -S --noconfirm \
      "keepassxc" \
      "veracrypt"
    exit 0
  elif [ "$2" = "sound" ]; then
    sudo pacman -S --noconfirm \
      "pulseaudio" \
      "pavucontrol" \
      "paprefs"
    exit 0
  elif [ "$2" = "network" ]; then
    sudo pacman -S --noconfirm \
      "net-tools" \
      "openssh" \
      "openvpn" \
      "networkmanager" \
      "nm-connection-editor" \
      "networkmanager-openvpn" \
      "tigervnc"
    exit 0
  elif [ "$2" = "firewall" ]; then
    sudo pacman -S --noconfirm "ufw" "gufw" && \
      sudo systemctl enable ufw.service && \
      sudo systemctl start ufw.service && \
      sudo ufw enable && sudo ufw logging off
    exit 0
  elif [ "$2" = "internet" ]; then
    sudo pacman -S --noconfirm \
      "wget" \
      "curl" \
      "chromium" \
      "rclone" \
      "surfraw" \
      "qbittorrent" \
      "firefox"
      # "uget"
    # yay -S --noconfirm "google-chrome" \
    #   "skypeforlinux-stable-bin" \
    #   "chromium-widevine" \
    #   "youtube-dlc"
    # TeamViewer on Arch is unstable...
    # yay -S --noconfirm "teamviewer" && \
    #   sudo systemctl restart teamviewerd.service
    exit 0
  elif [ "$2" = "docker" ]; then
    sudo pacman -S --noconfirm "docker" "docker-compose" && \
      sudo systemctl enable docker.service && \
      sudo systemctl start docker.service && \
      sudo usermod -aG docker $CF_USER
    # yay -S --noconfirm "kitematic"
    exit 0
  elif [ "$2" = "development" ]; then
    # Replace with gvim... pacman -R --noconfirm vim
    sudo pacman -S --noconfirm \
      "ripgrep" \
      "gvim" \
      "git" \
      "python" \
      "python-pip"
    yay -S --noconfirm "visual-studio-code-bin" \
      "pycharm-professional"
    exit 0
  elif [ "$2" = "archive" ]; then
    sudo pacman -S --noconfirm \
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
    sudo pacman -S --noconfirm \
      "xfce4" \
      "xfce4-notifyd" \
      "xfce4-taskmanager" \
      "xfce4-screensaver" \
      "xfce4-terminal" \
      "network-manager-applet" \
      "pasystray" \
      "mousepad" \
      "papirus-icon-theme"
    exit 0
  elif [ "$2" = "xfce-panel-plugins" ]; then
    sudo pacman -S --noconfirm \
      "xfce4-battery-plugin" \
      "xfce4-whiskermenu-plugin" \
      "xfce4-systemload-plugin" \
      "xfce4-sensors-plugin" \
      "xfce4-weather-plugin" \
      "xfce4-netload-plugin" \
      "xfce4-clipman-plugin"
    exit 0
  elif [ "$2" = "thunar" ]; then
    sudo pacman -S --noconfirm \
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
    yay -S --noconfirm "jmtpfs"
    exit 0
  elif [ "$2" = "media" ]; then
    sudo pacman -S --noconfirm \
      "viewnior" \
      "flameshot" \
      "peek" \
      "cmus" \
      "vlc" \
      "beets" \
      "mp3info" \
      "gimp"
    exit 0
  elif [ "$2" = "office" ]; then
    sudo pacman -S --noconfirm \
      "workrave" \
      "calibre" \
      "libreoffice-still"
    yay -S --noconfirm "foxitreader"
    exit 0
  fi
  >&2 echo 'Specify what to install' && exit 1
fi

if [ "$1" = "yay" ]; then
  install=$CF_BUILD
  if [ -d $install/yay ] || [ -x "$(command -v yay)" ]; then
    >&2 echo 'yay already installed'
  else
    mkdir -p $install && cd $install && \
      git clone --depth 1 https://aur.archlinux.org/yay.git && \
      cd yay && \
      makepkg -si
  fi
  exit 0
fi

if [ "$1" = "tpm" ]; then
  install=${HOME}/.tmux/plugins/tpm
  if [ ! -d $install ]; then
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$install"
  else
    >&2 echo 'tpm already installed'
  fi
  exit 0
fi

if [ "$1" = "zsh" ]; then
  if [ "$2" = "syntax-highlighting" ]; then
    install=$CF_BUILD
    # Note that this install path is hardcoded in .../zsh/modules/syntax
    if [ -d ${install}/zsh-syntax-highlighting ]; then
      >&2 echo 'zsh-syntax-highlighting already installed'
    else
      mkdir -p $install && cd $install && \
        git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git
    fi
    exit 0
  else
    chsh -s /bin/zsh
    exit 0
  fi
fi

if [ "$1" = "node" ]; then
  if [ "$2" = "packages" ] ; then
    # npm outdated -g --depth=0
    # npm update -g
    packages=(
      "npm@latest"
      "editorconfig"
      "prettier"
      "typescript"
      # "typescript-language-server"
      # "neovim"
    )
    for i in "${packages[@]}"; do
      npm install -g "$i"
    done
    exit 0
  else
    install=$HOME
    if [ -d ${install}/.nvm ]; then
      >&2 echo 'nvm already installed'
    else
      mkdir -p $install && cd $install && \
        git clone https://github.com/nvm-sh/nvm.git .nvm && \
        cd ${install}/.nvm && \
        git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)` && \
        export NVM_DIR="${install}/.nvm" && \
        [ -s "${NVM_DIR}/nvm.sh" ] && . "${NVM_DIR}/nvm.sh" && \
        nvm install --lts && nvm use --lts && \
        echo "lts/*" > "${HOME}/.nvmrc"
    fi
    exit 0
  fi
fi

if [ "$1" = "pip" ]; then
  packages3=(
    # "proselint"
    # "pynvim"
    # "yamllint"
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
