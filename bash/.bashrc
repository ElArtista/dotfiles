#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export HISTSIZE=3000
export EDITOR=vim

# Colored ls output in termite
eval $(dircolors ~/.dircolors)

alias ls='ls --color=auto'

alias wifi='sudo netctl'
alias poff='systemctl poweroff'
alias rbt='systemctl reboot'

alias glol='git log --oneline'
alias cls=clear

PS1='[\u@\h \W]\$ '

