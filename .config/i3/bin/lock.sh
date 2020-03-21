screenarea=$(xrandr --current | grep -oP '(?<=current )\d+ x \d+')
screenarea=${screenarea// /}
screens=( $(xrandr --current | grep -oP '\d+x\d+\+\d+\+\d+') )

convert -size $screenarea xc:black $GRAYSCALE -quality 11 png24:"$BACKGROUND"

if check_file_exists "$IMAGE"; then
for screen in "${screens[@]}"; do
    convert "$BACKGROUND" \
	\( "$IMAGE" -gravity Center -resize ${screen%%+*}^ -extent ${screen%%+*} \) \
	-gravity NorthWest -geometry +${screen#*+} -composite \
	$GRAYSCALE -quality 11 png24:"$BACKGROUND"
done
fi
