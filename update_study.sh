#!/bin/bash

# the file to store the study time information into
study_time_file="/home/user/documents/study/studied.txt"

update_study_time() {
    minutes_studied=$1
    study_duration=$((minutes_studied * 60))  # convert minutes to seconds

    if [ -f "$study_time_file" ]; then
        previous_time_string=$(sed -n '1p' "$study_time_file")
        existing_time=$(sed -n '2p' "$study_time_file")
        echo "--- $previous_time_string"
        
        if [ -n "$existing_time" ]; then
            total_time=$((existing_time + study_duration))
        else
            total_time="$study_duration"
        fi
    else
        previous_time_string="No previous study time recorded."
        echo "$previous_time_string"
        total_time="$study_duration"
    fi

    hours=$((total_time / 3600))
    minutes=$(( (total_time % 3600) / 60 ))
    seconds=$((total_time % 60))
    time_string="Total study time as of $(date +'%Y/%m/%d'): $hours hours, $minutes minutes, and $seconds seconds"

    echo "$time_string" > "$study_time_file"
    echo "$total_time" >> "$study_time_file"
    
    echo "+++ $time_string"
}

if [ $# -ne 1 ]; then
    echo "Usage: $0 <minutes_studied>"
    exit 1
fi

update_study_time $1

