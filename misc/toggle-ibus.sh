#! /usr/bin/env bash
ibus list-engine > /dev/null
enabled=$?
echo "ibus enabled:" $enabled
if [ $enabled -eq 0 ]; then
    echo "Stopping ibus..."
    ibus exit
else
    echo "Starting ibus..."
    ibus-daemon -dx
    sleep 0.1
    ibus engine pinyin
fi
