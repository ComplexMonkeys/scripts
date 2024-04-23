#!/bin/bash
maim -us > /tmp/s.png

if [ $? -ne 0 ]; then
    notify-send "Screenshot" "Capture cancelled"
    exit 1
fi

file_size=$(stat -c%s /tmp/s.png)
resize=100

if [ $file_size -gt 1048576 ]; then
    while [ $file_size -gt 1048576 ]; do
        resize=$((resize - 5))
        convert /tmp/s.png -resize $resize% -quality 80% /tmp/r.png
        file_size=$(stat -c%s /tmp/r.png)
    done
    xclip -selection clipboard -t image/png < /tmp/r.png
    notify-send "Screenshot" "Screenshot with a size of $(numfmt --to=iec-i --suffix=B $file_size) captured [resized to $resize%]"
    rm /tmp/r.png
else
    xclip -selection clipboard -t image/png < /tmp/s.png
    notify-send "Screenshot" "Screenshot with a size of $(numfmt --to=iec-i --suffix=B $file_size) captured"
fi

rm /tmp/s.png
