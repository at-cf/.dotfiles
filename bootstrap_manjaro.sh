#! /bin/bash

set -e

[[ $EUID = 0 ]] && >&2 echo "Do not run as root" && exit 1

mkdir -p $HOME/GoogleDrive
mkdir -p $HOME/Documents
mkdir -p $HOME/Downloads
mkdir -p $HOME/Development/.tmp
mkdir -p $HOME/Pictures/Screenshots
mkdir -p $HOME/.tmp
mkdir -p $HOME/.build
mkdir -p $HOME/Android

./install.sh link

sudo ./install.sh disable-core-dump
sudo ./install.sh disable-beep

if ! [ -x "$(command -v yay)" ]; then
  ./install.sh yay
fi

sudo ./install.sh pacman system
sudo ./install.sh pacman shell
sudo ./install.sh pacman security
sudo ./install.sh pacman sound
sudo ./install.sh pacman network
sudo ./install.sh pacman ufw
sudo ./install.sh pacman internet
sudo ./install.sh pacman virtualbox
sudo ./install.sh pacman development
sudo ./install.sh pacman archive
sudo ./install.sh pacman thunar
sudo ./install.sh pacman media
sudo ./install.sh pacman office

if [ -x "$(command -v yay)" ]; then
  ./install.sh yay packages
fi

./install.sh tpm

./install.sh zsh
./install.sh zsh spaceship-prompt
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