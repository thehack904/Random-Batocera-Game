#!/bin/bash
#
# Random Batocera Game Selector
# Version: 2.0
# Description: Randomly selects a game from ALL Batocera emulators for boot
# Author: thehack904
# License: GPL-3.0
#
# Version History:
#   v1.0 - Original script (MAME only)
#   v2.0 - Extended to support all Batocera emulators (110+ file extensions)
#          across all platforms (Nintendo, Sega, Sony, Atari, Arcade, etc.)
#

VERSION="2.0"

# Handle command line arguments
if [ "$1" = "--version" ] || [ "$1" = "-v" ]; then
    echo "Random Batocera Game Selector v${VERSION}"
    exit 0
fi

# Collect all game files from all emulator directories
files=()
for emulator_dir in /userdata/roms/*/; do
    # Skip if directory doesn't exist or is empty
    if [ -d "$emulator_dir" ]; then
        # Find all game files with extensions supported by Batocera emulators
        # This includes 110+ extensions across all platforms (Nintendo, Sega, Sony, 
        # Microsoft, Atari, Arcade, Computers, Handhelds, etc.)
        while IFS= read -r -d '' file; do
            files+=("$file")
        done < <(find "$emulator_dir" -maxdepth 1 -type f \( \
            -iname "*.zip" -o -iname "*.7z" -o -iname "*.rar" -o \
            -iname "*.iso" -o -iname "*.chd" -o -iname "*.cue" -o -iname "*.bin" -o -iname "*.img" -o \
            -iname "*.ccd" -o -iname "*.cdi" -o -iname "*.gdi" -o -iname "*.mds" -o -iname "*.pbp" -o \
            -iname "*.nes" -o -iname "*.unf" -o -iname "*.unif" -o \
            -iname "*.smc" -o -iname "*.sfc" -o -iname "*.fig" -o -iname "*.swc" -o -iname "*.mgd" -o \
            -iname "*.snes" -o -iname "*.n64" -o -iname "*.z64" -o -iname "*.v64" -o \
            -iname "*.gba" -o -iname "*.gb" -o -iname "*.gbc" -o -iname "*.nds" -o \
            -iname "*.3ds" -o -iname "*.3dsx" -o -iname "*.cia" -o \
            -iname "*.gcm" -o -iname "*.gcz" -o -iname "*.ciso" -o -iname "*.wbfs" -o -iname "*.wad" -o \
            -iname "*.wud" -o -iname "*.wux" -o -iname "*.rpx" -o \
            -iname "*.sms" -o -iname "*.gg" -o -iname "*.sg" -o \
            -iname "*.md" -o -iname "*.smd" -o -iname "*.gen" -o -iname "*.32x" -o \
            -iname "*.cso" -o -iname "*.mdf" -o -iname "*.vpk" -o \
            -iname "*.a26" -o -iname "*.a52" -o -iname "*.a78" -o \
            -iname "*.st" -o -iname "*.msa" -o -iname "*.stx" -o -iname "*.dim" -o \
            -iname "*.j64" -o -iname "*.jag" -o \
            -iname "*.vec" -o -iname "*.gam" -o \
            -iname "*.col" -o -iname "*.rom" -o -iname "*.int" -o \
            -iname "*.chf" -o \
            -iname "*.adf" -o -iname "*.adz" -o -iname "*.dms" -o -iname "*.ipf" -o \
            -iname "*.dsk" -o -iname "*.sna" -o -iname "*.do" -o -iname "*.po" -o -iname "*.nib" -o \
            -iname "*.d64" -o -iname "*.t64" -o -iname "*.prg" -o -iname "*.crt" -o -iname "*.tap" -o \
            -iname "*.mx1" -o -iname "*.mx2" -o \
            -iname "*.exe" -o -iname "*.bat" -o -iname "*.com" -o \
            -iname "*.lnx" -o -iname "*.ws" -o -iname "*.wsc" -o -iname "*.ngc" -o -iname "*.ngp" -o \
            -iname "*.min" -o \
            -iname "*.svm" -o -iname "*.scummvm" -o \
            -iname "*.p8" -o -iname "*.png" -o \
            -iname "*.pce" -o -iname "*.sgx" -o \
            -iname "*.vb" -o -iname "*.vboy" -o \
            -iname "*.tzx" -o -iname "*.z80" -o -iname "*.rzx" -o -iname "*.scl" -o -iname "*.trd" -o \
            -iname "*.d88" -o -iname "*.88d" -o -iname "*.hdm" -o -iname "*.dup" -o -iname "*.2hd" -o \
            -iname "*.xdf" -o -iname "*.hdf" -o -iname "*.cmd" -o -iname "*.m3u" \
            \) -print0 2>/dev/null)
    fi
done

# Check if any games were found
if [ ${#files[@]} -eq 0 ]; then
    echo "No games found in /userdata/roms/"
    exit 1
fi

# Randomly select a game
new_game="${files[RANDOM % ${#files[@]}]}"

# Escape special characters for sed replacement string
# This handles characters like &, \, and / that have special meaning in sed
escaped_game=$(echo "$new_game" | sed 's/[&/\]/\\&/g')

# Check if boot game is configured in batocera.conf
if ! grep -q "global.bootgame.cmd" /userdata/system/batocera.conf; then
    echo "Error: No boot game configured in batocera.conf"
    echo "Please configure a game to start on boot first, then run this script again."
    exit 1
fi

# Replace the old game with the new game in batocera.conf
# Update the -rom parameter in global.bootgame.cmd
sed -i "s|\(-rom \)[^ ]*|\1${escaped_game}|" /userdata/system/batocera.conf

# Update the -systemname parameter in global.bootgame.cmd
sed -i "s|\(-systemname \)[^ ]*|\1${escaped_game}|" /userdata/system/batocera.conf

# Update global.bootgame.path to point to the new game
sed -i "s|^global\.bootgame\.path=.*|global.bootgame.path=${escaped_game}|" /userdata/system/batocera.conf

echo "Selected random game: $new_game"
