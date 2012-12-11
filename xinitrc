# remap caps lock to control
xmodmap -e 'remove Lock = Caps_Lock'
xmodmap -e 'keysym Caps_Lock = Control_L'
xmodmap -e 'add Control = Control_L'

# set a normal default pointer
xsetroot -cursor_name left_ptr

# disable the bell
xset -b

# load settings for the terminal
xrdb ~/.Xresources.solarized
xrdb -merge ~/.Xresources

# finally start Xmonad
xmonad
