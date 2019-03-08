#!/bin/bash
# Inspired by https://aaronlasseigne.com/2012/10/15/battery-life-in-the-land-of-tmux/

language=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | egrep -w 'KeyboardLayout Name' | sed -E 's/^.+ = \"?([^\"]+)\"?;$/\1/')

if [[ $language == "Spanish - ISO" ]]; then
    echo "SPA"
else
    echo "U.S."
fi
