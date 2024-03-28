#!/bin/bash
if [ "$#" -ne 2 ]; then
	echo "Usage: $0 <audio_track_numbers> <subtitle_track_numbers>"
	echo "Both number start from 0 and count total tracks"
  exit 1
fi

audio_tracks=$1
subtitle_tracks=$2

mkdir ".archive"

for file in *.mkv; do
  mv "$file" "old_${file}"
  
  # Run mkvmerge to create a new file with selected tracks
  mkvmerge -o "${file}" -a "$audio_tracks" -s "$subtitle_tracks" "old_${file}"
  
  # Get the number of tracks in the new file
  num_tracks=$(mkvinfo "$file" | grep -c "Track type:")

  # Remove titles from all tracks
  mkvpropedit "$file" --edit info --delete title --delete-attachment "mime-type:image/jpeg"
  for ((i = 1; i <= num_tracks; i++)); do
    mkvpropedit "$file" --edit track:$i --delete name
  done
  mv "old_${file}" ".archive/"
done

