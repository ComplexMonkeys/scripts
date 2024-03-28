#!/bin/bash
num=$1
string=$2

echo "Renamed files:"
find . -type f -name '*.mp4' | sort -n | while read file; do
    newname="$(printf '%s%02d' $string $num).${file##*.}"
    echo "$file -> $newname"
    ((num++))
done

read -p "Proceed with the operation? [y/n] " choice
if [[ $choice =~ ^[Yy]$ ]]
then
    i=$1
    find . -type f -name '*.mp4' | sort -n | while read file; do
        mv "$file" "$(printf '%s%02d' $string $num).${file##*.}"
        ((num++))
    done
    echo "Files renamed successfully."
else
    echo "Operation cancelled."
fi
