#!/bin/bash

# Collect all game files from all emulator directories
files=()
for emulator_dir in /userdata/roms/*/; do
    # Skip if directory doesn't exist or is empty
    if [ -d "$emulator_dir" ]; then
        # Find all game files with common extensions in one pass
        while IFS= read -r -d '' file; do
            files+=("$file")
        done < <(find "$emulator_dir" -maxdepth 1 -type f \( \
            -iname "*.zip" -o -iname "*.nes" -o -iname "*.snes" -o -iname "*.sfc" -o \
            -iname "*.n64" -o -iname "*.z64" -o -iname "*.v64" -o -iname "*.gba" -o \
            -iname "*.gb" -o -iname "*.gbc" -o -iname "*.nds" -o -iname "*.smd" -o \
            -iname "*.bin" -o -iname "*.gen" -o -iname "*.md" -o -iname "*.sms" -o \
            -iname "*.gg" -o -iname "*.sg" -o -iname "*.cue" -o -iname "*.iso" -o \
            -iname "*.chd" -o -iname "*.pbp" -o -iname "*.7z" -o -iname "*.ccd" -o \
            -iname "*.img" \) -print0 2>/dev/null)
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
old_game=$(grep global.bootgame.cmd /userdata/system/batocera.conf | awk '{print $NF}')

# Check if old_game was found
if [ -z "$old_game" ]; then
    echo "Error: No boot game configured in batocera.conf"
    echo "Please configure a game to start on boot first, then run this script again."
    exit 1
fi

# Replace the old game with the new game in batocera.conf
# Use a more precise pattern that matches the entire line
sed -i "s|^\(global\.bootgame\.cmd.*\)${old_game}|\1${new_game}|g" /userdata/system/batocera.conf

echo "Selected random game: $new_game"
