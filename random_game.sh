#!/bin/bash

# Collect all game files from all emulator directories
files=()
for emulator_dir in /userdata/roms/*/; do
    # Skip if directory doesn't exist or is empty
    if [ -d "$emulator_dir" ]; then
        # Add all common game file extensions
        for ext in zip nes snes sfc n64 z64 v64 gba gb gbc nds smd bin gen md sms gg sg cue iso chd pbp 7z ccd img; do
            while IFS= read -r -d '' file; do
                files+=("$file")
            done < <(find "$emulator_dir" -maxdepth 1 -type f -iname "*.$ext" -print0 2>/dev/null)
        done
    fi
done

# Check if any games were found
if [ ${#files[@]} -eq 0 ]; then
    echo "No games found in /userdata/roms/"
    exit 1
fi

# Randomly select a game
new_game="${files[RANDOM % ${#files[@]}]}"

# Get the current boot game from batocera.conf
old_game=`grep global.bootgame.cmd /userdata/system/batocera.conf | awk '{print $NF}'`

# Replace the old game with the new game in batocera.conf
sed -i "s|$old_game|$new_game|g" /userdata/system/batocera.conf

echo "Selected random game: $new_game"
