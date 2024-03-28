#!/bin/bash
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

if pgrep -f "ffmpeg -f x11grab" >/dev/null; then
    pkill -f "ffmpeg -f x11grab"
else
    if [ "$no_audio" = true ]; then
        record -n &
    else
        record &
    fi
fi

