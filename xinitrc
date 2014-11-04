xrdb -merge .Xresources

# set a normal default pointer
xsetroot -cursor_name left_ptr

# disable the bell
xset -b

# Turn the caps lock key into an extra control key.
setxkbmap -option 'ctrl:nocaps'

# Disable trackpad tapping.
synclient TapButton1=0 TapButton2=0 TapButton3=0

trayer --edge top --align right --SetDockType true --SetPartialStrut true \
 --expand true --width 10 --transparent true --height 12 --tint 0x000000 &

nm-applet &

dropboxd &

exec xmonad
