#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    /usr/bin/xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    /usr/bin/xmodmap $sysmodmap
fi

if [ -f $userresources ]; then
    /usr/bin/xrdb -merge $userresources
fi

if [ -f $usermodmap ]; then
    /usr/bin/xmodmap $usermodmap
fi

xbindkeys
xautolock -time 30 &>/dev/null &
hsetroot -solid "#000000"
xcompmgr -c -n -f &>/dev/null &
feh --bg-fill ~/wallpapers/wallpaper.jpg
xset +fp /usr/share/fonts/terminus/

xrandr --output DVI-I-1 --auto
xrandr --output DP-1 --auto --left-of DVI-I-1
xrandr --output DVI-D-0 --auto --right-of DVI-I-1 --rotate left

ssh-add

exec /usr/bin/spectrwm 2&> $HOME/.spectrwm.log
