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

## Installation

### Easy Installation (Recommended)

The easiest way to install is using the automated installer:

1. **SSH into your Batocera system** or open a terminal
2. **Download and run the installer:**
   ```bash
   cd /tmp
   wget https://raw.githubusercontent.com/thehack904/Random-Batocera-Game/main/install.sh
   chmod +x install.sh
   ./install.sh
   ```
   
   Or if you have the repository cloned:
   ```bash
   cd /path/to/Random-Batocera-Game
   ./install.sh
   ```

3. **Configure a boot game** (if not already done):
   - Select any game in EmulationStation
   - Press 'A' (or South button) for Game Options
   - Go to 'Advanced Game Options'
   - Enable 'Boot this game on startup'

4. **Reboot** and enjoy your random game!

**To uninstall:**
```bash
./install.sh uninstall
```

### Manual Installation

If you prefer to install manually:

1. **Configure a boot game first:**
   - Start your Batocera system and select any game from any emulator
   - Set the game's advanced settings (Hold A or south button)
   - Scroll down and set to start on boot

2. **Install the script:**
   ```bash
   # SSH into your Batocera system
   cd /userdata/system
   
   # Download the script
   wget https://raw.githubusercontent.com/thehack904/Random-Batocera-Game/main/random_game.sh
   
   # Make it executable
   chmod +x random_game.sh
   
   # Add to custom.sh
   echo "/userdata/system/random_game.sh" >> /userdata/system/custom.sh
   chmod +x /userdata/system/custom.sh
   
   # Test it
   /userdata/system/random_game.sh
   ```

3. **Reboot** to verify it works

## Usage

Once installed, the script runs automatically on each boot, selecting a random game.

**Check the version:**
```bash
/userdata/system/random_game.sh --version
```

**Manually run to change boot game:**
```bash
/userdata/system/random_game.sh
```

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
