#! /bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    [ -x "$f" ] && source "$f"
  done
  unset f
fi

[ -f "$HOME/.Xresources" ] && xrdb -merge "$HOME/.Xresources"
[ -f "$HOME/.Xmodmap" ] && xmodmap "$HOME/.Xmodmap"
[ -f "$HOME/.xprofile" ] && source "$HOME/.xprofile"

exec startxfce4
