# remap caps lock to control
xmodmap -e 'remove Lock = Caps_Lock'
xmodmap -e 'keysym Caps_Lock = Control_L'
xmodmap -e 'add Control = Control_L'

# set a normal default pointer
xsetroot -cursor_name left_ptr

# disable the bell
xset -b

# start VirtualBox services, if they exist
command -v VBoxClient-all > /dev/null && VBoxClient-all

# gnome-terminal needs to be forced into the right hinting mode
xrdb ~/.Xresources

# finally start Xmonad
xmonad
