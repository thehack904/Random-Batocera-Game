# Random-Batocera-Game
Start random game on boot up for Batocera

This script will start a random game from **any** emulator every time Batocera system boots up. It's fun to never know what game or system you might get! The script will scan all emulator directories in /userdata/roms/ and randomly pick a game from your entire collection. You can put this in your /userdata/system/custom.sh file or create the script random_game.sh, then call it in the custom.sh. You will also need to mark one of your games initially in its advanced settings to start at boot. That will put the syntax in that the script can update/change.

Enjoy!

To setup:
Start your Batocera system and select any game from any emulator, set the game's advanced settings (Hold A or south button) and scroll down and set to start on boot

    Open a command line window or ssh into your Batocera system
    Type: cd /userdata/system
    Type: vi random_game.sh
    Type: i
    Paste contents of script below
    Press esc
    Type: :wq!
    Type: chmod +x random_game.sh
    Type: echo /userdata/system/random_game.sh >> /userdata/system/custom.sh
    (If you don’t have a custom.sh already) Type: chmod +x /userdata/system/custom.sh
    Type: /userdata/system/random_game.sh

That should change the first game you selected to a new game for the next boot/reboot.
To check that it works, reboot.
