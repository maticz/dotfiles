# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

export GOPATH="$HOME/Development/src/go"
export PATH="$GOPATH/bin:/usr/local/go/bin:/usr/pgsql-11/bin:$PATH"

export HISTFILESIZE=100000
export HISTSIZE=100000

export VISUAL='nvim'
export EDITOR="$VISUAL"

# Hack to make ls output in Alacritty colorful
eval "$(TERM=gnome dircolors --sh /etc/DIR_COLORS.lightbgcolor)"
export USER_LS_COLORS="$LS_COLORS"
