#! /bin/bash

set -e

# XFCE only <3
# Still need to review install.sh for extra/manual steps...

HOST_OS=${1}
[ -z "$HOST_OS" ] && >&2 echo "Specify arch or manjaro" && exit 1
[[ $EUID = 0 ]] && >&2 echo "Do not run as root" && exit 1

./install.sh system home-dirs
./install.sh link
./install.sh pacman system
./install.sh yay
if [ "$HOST_OS" = "arch" ]; then
  ./install.sh pacman x
  ./install.sh pacman xfce
fi
./install.sh pacman xfce-panel-plugins
./install.sh pacman shell
./install.sh pacman security
./install.sh pacman sound
./install.sh pacman network
./install.sh pacman firewall
./install.sh pacman internet
./install.sh pacman docker
./install.sh pacman development
./install.sh pacman archive
./install.sh pacman thunar
./install.sh pacman media
./install.sh pacman office
./install.sh tpm
./install.sh zsh && ./install.sh zsh syntax-highlighting
./install.sh pip
./install.sh node nvm && . "~/.nvm/nvm.sh" && ./install.sh node packages
# Below here is not safe to run multiple times...
./install.sh system disable-core-dump
./install.sh system disable-beep
echo "Setup complete, reboot..."
# After reboot:
# xfconf-query -c xfce4-session -p /general/LockCommand -s "slock" --create -t string

