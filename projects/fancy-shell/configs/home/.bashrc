# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#. $HOME/bin/agent-mgr

HISTCONTROL=ignoreboth

shopt -s histappend

HISTSIZE=1000000
HISTFILESIZE=2000000

shopt -s checkwinsize

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

unset color_prompt force_color_prompt

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export EDITOR=$(which vim)
export PATH=$PATH:~/bin:/sbin:/usr/sbin
export PS1='\n\u@\h:\w\n\$ '

alias vi=$EDITOR

export GOPATH=$HOME/goworkspace

ulimit -c unlimited

function retitle() {
  screen -X title "$1"
}

export TERM=$(echo $TERM | sed 's/screen.//')

