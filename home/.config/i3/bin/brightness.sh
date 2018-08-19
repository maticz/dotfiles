#!/bin/bash

# You can call this script like this:
# $./brightness.sh up
# $./brightness.sh down

case $1 in
    up)
	xbacklight -inc 10
	v=$(xbacklight -get)
	value="${v%.*}"
	notify-send -a "Brightness" " " -h "int:value:$value"
	;;
    down)
	xbacklight -dec 10
	v=$(xbacklight -get)
	value="${v%.*}"
	notify-send -a "Brightness" " " -h "int:value:$value"
	;;
esac
