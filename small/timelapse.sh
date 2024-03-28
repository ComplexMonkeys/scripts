#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Usage: <input_file> <decimal_part>"
    exit 1
fi

input_file=$1
decimal_part=$2
decimal_part="0.$decimal_part"

if [ ! -f "$input_file" ]; then
    echo "Input file '$input_file' not found."
    exit 1
fi

output_file="${input_file%.mp4}l.mp4"

ffmpeg -i "$input_file" -vf "setpts=${decimal_part}*PTS" "$output_file"

