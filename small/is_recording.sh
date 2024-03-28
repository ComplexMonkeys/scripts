#!/bin/bash
start_time_file="/tmp/rec_start_time"
format_duration() {
    local total_seconds="$1"
    local minutes=$(( total_seconds / 60 ))
    local seconds=$(( total_seconds % 60 ))
    printf "%02d:%02d" "$minutes" "$seconds"
}

if pgrep -f "ffmpeg -f x11grab" >/dev/null; then
    window_title=$(cat /tmp/recd)

    if [ -f "$start_time_file" ]; then
        start_time=$(cat "$start_time_file")
        duration=$(( $(date +%s) - start_time ))
        formatted_duration=$(format_duration "$duration")
        echo "RECORDING [$window_title][$formatted_duration]"
    else
        date +%s > "$start_time_file"
        echo "RECORDING [$window_title]"
    fi
else
    rm -f "$start_time_file"
    echo ""
fi

