#!/bin/bash

# You can call this script like this:
# $./brightness.sh up
# $./brightness.sh down

case $1 in
    up)
	light -A 10
	v=$(light -G)
	value="${v%.*}"
	notify-send -a "Brightness" " " -h "int:value:$value"
	;;
    down)
	light -U 10
	v=$(light -G)
	value="${v%.*}"
	notify-send -a "Brightness" " " -h "int:value:$value"
	;;
esac
