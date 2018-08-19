# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

export GOPATH="$HOME/Development/src/go"
export PATH="$GOPATH/bin:$PATH"

export HISTFILESIZE=100000
export HISTSIZE=100000

alias vim='gvim -v'

export VISUAL='gvim -v'
export EDITOR="$VISUAL"
