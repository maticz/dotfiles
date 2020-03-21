#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:/usr/local/go/bin:/usr/pgsql-11/bin:$PATH"

export HISTFILESIZE=100000
export HISTSIZE=100000

export VISUAL='nvim'
export EDITOR="$VISUAL"

export GOPRIVATE=github.com/Zemanta/,*.outbrain.com

alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
