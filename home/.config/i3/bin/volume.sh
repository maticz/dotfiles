#!/bin/bash

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

case $1 in
	up)
		# Set the volume on (if it was muted)
		#amixer -D pulse set Master on > /dev/null
		pactl set-sink-mute 1 1
		# Up the volume (+ 5%)
		pactl set-sink-volume 1 +5%
		#amixer -D pulse sset Master 5%+ > /dev/null
	;;
	down)
		#amixer -D pulse set Master on > /dev/null
		#amixer -D pulse sset Master 5%- > /dev/null
		pactl set-sink-mute 1 0
		pactl set-sink-volume 1 -5%
	;;
	mute)
		# Toggle mute
		#amixer -D pulse set Master 1+ toggle > /dev/null
		pactl set-sink-mute 1 toggle
	;;
	mic)
		# Toggle microphone
		#amixer -D pulse set Capture toggle
		#pactl set-sink-input-mute 2 toggle
		pactl set-source-mute 2 toggle 
	;;
esac
