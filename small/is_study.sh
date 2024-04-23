#!/bin/bash
session_flag="/tmp/flagd"

format_duration() {
    local total_seconds="$1"
    local minutes=$(( total_seconds / 60 ))
    local seconds=$(( total_seconds % 60 ))
    printf "%02d:%02d" "$minutes" "$seconds"
}

display_session_duration() {
    if [ -f "$session_flag" ]; then
        session_type=$(cat "$session_flag")

        if [ "$session_type" == "study" ]; then
            total_duration=$(( 90 * 60 ))
            session_name="Study"
        elif [ "$session_type" == "break" ]; then
            total_duration=$(( 10 * 60 ))
            session_name="Break"
        else
            total_duration=0
            session_name=""
        fi

	current_time=$(date +%s)
        start_time=$(stat -c %Y "$session_flag")
        elapsed_seconds=$(( current_time - start_time ))
        remaining_seconds=$(( total_duration - elapsed_seconds ))

        if [ "$remaining_seconds" -le 0 ]; then
            echo "00:00"
        else
            formatted_remaining=$(format_duration "$remaining_seconds")
            echo "$session_name[$formatted_remaining]"
        fi
    else
        echo ""
    fi
}

display_session_duration
