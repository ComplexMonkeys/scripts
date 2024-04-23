#!/bin/bash
session_flag="/tmp/flagd"
start_time_file="/tmp/studyd"
study_time_file="/home/user/documents/study/studied"
is_break=false

send_notification() {
    local summary="$1"
    local body="$2"
    notify-send -t 5000 "$summary" "$body"
}

start_study() {
    send_notification "Time to study" "Stay focused for the next 90 minutes!"
    date +%s > "$start_time_file"
    echo "study" > "$session_flag"
}

start_break() {
    send_notification "Relax and decompress!" "You are done with the studies, now take 10 minutes to relax and deliberately defocus."
    date +%s > "$start_time_file"
    echo "break" > "$session_flag"
    is_break=true
}

update_study_time() {
    if [ -f "$start_time_file" ]; then
        start_time=$(cat "$start_time_file")
        end_time=$(date +%s)
        study_duration=$((end_time - start_time))

        if [ -f "$study_time_file" ]; then
            existing_time=$(sed -n '2p' "$study_time_file")
            if [ -n "$existing_time" ]; then
                total_time=$((existing_time + study_duration))
            else
                total_time="$study_duration"
            fi
        else
            total_time="$study_duration"
        fi

        hours=$((total_time / 3600))
        minutes=$(( (total_time % 3600) / 60 ))
        seconds=$((total_time % 60))
        time_string="Total study time: $hours hours, $minutes minutes, and $seconds seconds"

        echo "$time_string" > "$study_time_file"
        echo "$total_time" >> "$study_time_file"

        rm "$start_time_file"
    fi
}

trap "exit" INT
trap 'if [ "$is_break" = true ]; then notify-send -t 28000 "Session complete!" "Congratulations! You have successfully completed your study session!"; else update_study_time; fi && rm "$session_flag" && rm "$start_time_file" && paplay "/home/user/bash/res/done.mp3"' EXIT

if [ -z "$1" ]; then
    start_study
    sleep $((90*60))
    update_study_time
    start_break
    sleep $((10*60))
elif [ "$1" = "pause" ]; then
    start_break
    sleep $((10*60))
else
    echo "Invalid argument. Usage: $0 [pause]"
    exit 1
fi
