#!/bin/bash
trap "exit" INT
trap 'notify-send "Screen Recording" "Recording completed." && rm /tmp/recd' EXIT

usage() {
    echo "Usage: $0 [-n]" 1>&2
    echo "Options:" 1>&2
    echo "  -n  capture video without audio" 1>&2
    exit 1
}

while getopts ":n" opt; do
    case $opt in
        n)
            no_audio=true
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
    esac
done
shift $((OPTIND -1))

WINDOWID=$(xdotool getactivewindow)
WINDOW_TITLE=$(xdotool getwindowname $WINDOWID)
GEOMETRY=$(xdotool getwindowgeometry $WINDOWID)

echo "$WINDOW_TITLE" | tr '[:lower:]' '[:upper:]' > /tmp/recd

WIDTH=$(echo "$GEOMETRY" | grep 'Geometry' | awk '{print $2}' | cut -d'x' -f1)
HEIGHT=$(echo "$GEOMETRY" | grep 'Geometry' | awk '{print $2}' | cut -d'x' -f2)
X_OFFSET=$(echo "$GEOMETRY" | grep 'Position' | awk '{print $2}' | cut -d',' -f1)
Y_OFFSET=$(echo "$GEOMETRY" | grep 'Position' | awk '{print $2}' | cut -d',' -f2)

TARGET_WIDTH=854
TARGET_HEIGHT=480

if [ "$no_audio" = true ]; then
    ffmpeg -f x11grab -framerate 24 -video_size "$WIDTH"x"$HEIGHT" -i :0.0+"$X_OFFSET","$Y_OFFSET" \
           -vf "scale=$TARGET_WIDTH:$TARGET_HEIGHT" \
           -c:v libx264 -pix_fmt yuv420p -preset ultrafast -crf 30 \
           "$HOME/$(date +%s).mp4"
else
    ffmpeg -f x11grab -framerate 24 -video_size "$WIDTH"x"$HEIGHT" -i :0.0+"$X_OFFSET","$Y_OFFSET" \
           -f pulse -i default \
           -vf "scale=$TARGET_WIDTH:$TARGET_HEIGHT" \
           -c:v libx264 -pix_fmt yuv420p -preset ultrafast -crf 30 \
           -c:a aac -b:a 128k \
           "$HOME/$(date +%s).mp4"
fi
