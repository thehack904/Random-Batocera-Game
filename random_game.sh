#!/bin/bash
files=(/userdata/roms/mame/*.zip)
new_game=`printf “%s\n” “${files[RANDOM % ${#files[@]}]}”`
old_game=`grep global.bootgame.cmd /userdata/system/batocera.conf | awk -F “ ” ‘{print $6}’`

sed -i “s|$old_game|$new_game|g” /userdata/system/batocera.conf
