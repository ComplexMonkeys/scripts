#!/bin/bash
for file in *.mp4; do
  ffmpeg -i "$file" -vcodec copy -acodec copy "${file%.*}.mkv"
done
