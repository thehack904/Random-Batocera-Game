# Random-Batocera-Game
Start random game on boot up for Batocera

This script will start a random mame game every time batocera systems boots up. Its fun to never know what game I might get. It will scan the /userdata/roms/mame directory and pick a game. You can put this in your /userdata/system/custom.sh file or create the script random_game.sh, then call it in the custom.sh. You will also need to mark one of your games initially in its advanced settings to start at boot. That will put the syntax in that the script can update/change.

Enjoy!

To setup:
Start your Batocera system and select a mame game, set the games advanced settings (Hold A or south button) and scroll down and set to start on boot

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
