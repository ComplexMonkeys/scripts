#!/bin/bash
session_flag="/tmp/flagd"

if pgrep -f "/bin/study" >/dev/null; then
    if [ -f "$session_flag" ]; then
        session_type=$(cat "$session_flag")
        if [ "$session_type" = "study" ]; then
            pkill -f "/bin/study"
            echo "Study session stopped prematurely. Moving to break phase."
            study pause
        elif [ "$session_type" = "break" ]; then
            echo "Ending study session."
            pkill -f "/bin/study"
        fi
    fi
else
    echo "Starting study session."
    study &
fi

