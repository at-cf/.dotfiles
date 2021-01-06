#! /bin/bash

set -e

if ! [ -x "$(command -v xfce4-about)" ]; then
  >&2 echo "Install https://manjaro.org/downloads/official/xfce/" && exit 1
fi

[[ $EUID = 0 ]] && >&2 echo "Do not run as root" && exit 1

echo "This script will prompt for confirms/passwords..."

export CF_USER=$USER

mkdir -p $HOME/GoogleDrive
mkdir -p $HOME/Documents
mkdir -p $HOME/Downloads
mkdir -p $HOME/Development/.tmp
mkdir -p $HOME/Pictures/Screenshots
mkdir -p $HOME/.tmp
mkdir -p $HOME/.build
mkdir -p $HOME/Android

./install.sh link

sudo ./install.sh pacman system

if ! [ -x "$(command -v yay)" ]; then
  ./install.sh yay
fi

sudo ./install.sh pacman shell
sudo ./install.sh pacman security
sudo ./install.sh pacman sound
sudo ./install.sh pacman network
sudo ./install.sh pacman ufw
sudo ./install.sh pacman internet
sudo ./install.sh pacman docker
sudo ./install.sh pacman development
sudo ./install.sh pacman archive
sudo ./install.sh pacman thunar
sudo ./install.sh pacman xfce-panel-plugins
sudo ./install.sh pacman media
sudo ./install.sh pacman office

if [ -x "$(command -v yay)" ]; then
  yay -S --noconfirm "jmtpfs"
  yay -S --noconfirm "visual-studio-code-bin"
  if [ -x "$(command -v docker)" ]; then
    yay -S --noconfirm "kitematic"
  fi
  # yay -S --noconfirm "google-chrome"
  yay -S --noconfirm "pycharm-professional"
  # yay -S --noconfirm "ttf-windows"
  yay -S --noconfirm "foxitreader"
  yay -S --noconfirm "teamviewer"
  # If TeamViewer won't find connection, it's a permission error:
  # sudo systemctl restart teamviewerd.service
fi

if [ -x "$(command -v docker)" ]; then
  sudo usermod -aG docker $CF_USER
fi

./install.sh tpm

./install.sh zsh
./install.sh zsh syntax-highlighting

./install.sh node && \
  export NVM_DIR="$HOME/.nvm" && \
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
  nvm install --lts && \
  nvm use --lts && \
  echo "lts/*" > .nvmrc && \
  ./install.sh node packages

./install.sh pip

echo "Manjaro setup complete, reboot..."

sudo ./install.sh disable-core-dump
sudo ./install.sh disable-beep
