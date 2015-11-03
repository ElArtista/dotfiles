[ -f ~/.xprofile ] && . ~/.xprofile

# Mute the f***ing bell
xset -b

# Disable touchpad while typing
syndaemon -i 1 -d

exec bspwm-session
