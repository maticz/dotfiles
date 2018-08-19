#!/bin/bash

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

case $1 in
	up)
		# Set the volume on (if it was muted)
		amixer -D pulse set Master on > /dev/null
		# Up the volume (+ 5%)
		amixer -D pulse sset Master 5%+ > /dev/null
	;;
	down)
		amixer -D pulse set Master on > /dev/null
		amixer -D pulse sset Master 5%- > /dev/null
	;;
	mute)
		# Toggle mute
		amixer -D pulse set Master 1+ toggle > /dev/null
	;;
	mic)
		# Toggle microphone
		amixer -D pulse set Capture toggle
	;;
esac
