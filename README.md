# Random-Batocera-Game
**Version 2.0** - Start random game on boot up for Batocera

This script will start a random game from **ALL** Batocera emulators every time the system boots up. It's fun to never know what game or system you might get! The script supports **110+ file extensions** across all Batocera platforms including:

- **Nintendo**: NES, SNES, N64, GameBoy, GBA, GameCube, Wii, Wii U, 3DS, DS, Virtual Boy
- **Sega**: Master System, Game Gear, Genesis/Mega Drive, 32X, Sega CD, Saturn, Dreamcast
- **Sony**: PlayStation (PSX), PS2, PS3, PSP, PS Vita
- **Microsoft**: Xbox, Xbox 360
- **Atari**: 2600, 5200, 7800, ST, Jaguar
- **Arcade**: MAME, FBNeo, Neo Geo, Naomi
- **Handhelds**: Lynx, WonderSwan, Neo Geo Pocket, PokeMini
- **Computers**: Amiga, C64, Amstrad CPC, MSX, Apple II, ZX Spectrum, DOS/PC, Sharp X68000
- **Other**: PC Engine/TurboGrafx, Vectrex, ColecoVision, Intellivision, ScummVM, PICO-8

The script scans all emulator directories in /userdata/roms/ and randomly picks a game from your entire collection. You can put this in your /userdata/system/custom.sh file or create the script random_game.sh, then call it in the custom.sh. You will also need to mark one of your games initially in its advanced settings to start at boot. That will put the syntax in that the script can update/change.

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

## Version History

### Version 2.0 (Current)
- **Major Enhancement**: Extended support from MAME-only to ALL Batocera emulators
- Added support for **112 unique file extensions** (up from 2-3)
- Platform coverage includes:
  - Nintendo systems (NES, SNES, N64, GB, GBA, GameCube, Wii, Wii U, 3DS, DS, Virtual Boy)
  - Sega systems (Master System, Game Gear, Genesis, 32X, Sega CD, Saturn, Dreamcast)
  - Sony systems (PlayStation, PS2, PS3, PSP, PS Vita)
  - Microsoft systems (Xbox, Xbox 360)
  - Atari systems (2600, 5200, 7800, ST, Jaguar)
  - Arcade systems (MAME, FBNeo, Neo Geo, Naomi)
  - Handheld systems (Lynx, WonderSwan, Neo Geo Pocket, PokeMini)
  - Computer systems (Amiga, C64, Amstrad CPC, MSX, Apple II, ZX Spectrum, DOS/PC, X68000)
  - Other systems (PC Engine, Vectrex, ColecoVision, Intellivision, ScummVM, PICO-8)
- Optimized performance with single find command per directory
- Added comprehensive error handling
- Modernized bash syntax (using `$()` instead of backticks)
- Added validation for missing boot game configuration

### Version 1.0 (Original)
- Initial release
- Supported MAME games only from `/userdata/roms/mame/` directory
- Basic functionality with minimal error handling
