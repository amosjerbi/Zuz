# Retrom - Retro Game ROM Manager

Retrom is a shell script utility designed to help you manage and download retro game ROMs from Internet Archive collections, obviously you'll need to update your links yourself due to legal reasons.

## Version 2 Updates

Version 2 introduces significant new features:

- **SMB Network Support**: Connect to SMB shares on your local network to access ROMs
- **Multi-OS Compatibility**: Optimized SMB mounting for MacOS, Windows, and Linux servers
- **Network Auto-Discovery**: Automatic scanning for SMB servers on your local network
- **Improved Directory Management**: Enhanced handling of ROM directories with network support

## Usage

1. Make the script executable:
   ```
   chmod +x Retrom_v2.sh
   ```

2. Run the script:
   ```
   ./Retrom_v2.sh
   ```
   
   You can also specify a custom ROM directory:
   ```
   ./Retrom_v2.sh /path/to/custom/directory
   ```

3. Follow the interactive prompts to manage your ROM collection

## Default ROM Directory

When you run the script:
- If this directory already exists, the script will notify you
- If it doesn't exist, you'll be asked if you want to create it
- You can choose a different location at any time through the menu

By default, ROMs are stored in
   ```
   $HOME/smb-mount/games-roms/
   ```

You can also customize the location by:
1. Setting the `ROMS_BASE_DIR` variable in the script
2. Passing a directory path as a command-line argument
3. Connecting to an SMB share that contains your ROMs

## Supported Platforms

| Platform | ROM Directory | Description |
|----------|--------------|----------------|
| NES | nes | Nintendo Entertainment System |
| SNES | snes | Super Nintendo Entertainment System |
| Genesis | genesis | Sega Genesis |
| Game Boy | gb | Game Boy |
| Game Boy Advance | gba | Game Boy Advance |
| Game Boy Color | gbc | Game Boy Color |
| Game Gear | gamegear | Sega Game Gear |
| Neo Geo Pocket | ngp | Neo Geo Pocket |
| Master System | mastersystem | Sega Master System |
| Sega CD | segacd | Sega CD |
| Sega 32X | sega32x | Sega 32X |
| Saturn | saturn | Sega Saturn |
| TurboGrafx-16 | tg16 | TurboGrafx-16 |
| TurboGrafx-CD | tgcd | TurboGrafx-CD |
| PlayStation | ps1 | PlayStation |
| PlayStation 2 | ps2 | PlayStation 2 |
| Nintendo 64 | n64 | Nintendo 64 |
| Dreamcast | dreamcast | Sega Dreamcast |
| Atari Lynx | lynx | Atari Lynx |

## Requirements

- Bash shell
- curl (for downloading ROMs)
- Internet connection
- Sufficient disk space for ROM storage
- rsync (optional, for improved ROM copying functionality)

## Features

- **Interactive Menu System**: Easy-to-use interface for managing your ROM collection
- **Smart Directory Management**: Checks if the default ROM directory exists and offers to create it
- **Multi-Platform Support**: Download ROMs for a wide variety of retro gaming platforms
- **Flexible ROM Storage**: Customize where your ROMs are stored or use the default location
- **Search Functionality**: Find specific ROMs across all supported platforms
- **Bulk Downloads**: Download entire ROM collections for any supported platform
- **Directory Verification**: Ensure all ROM directories are properly set up
- **Archive URL Testing**: Verify that all Internet Archive sources are accessible
- **External Storage Support**: Copy your ROM collection to external drives
- **Selection and Highlighting**: Ability to highlight and select items for better visual feedback and interaction
- **Network SMB Support**: Connect to SMB shares on your local network
- **Auto-Discovery**: Automatically scan and find SMB servers on your network
- **Multi-OS Compatibility**: Optimized mounting for MacOS, Windows, and Linux SMB servers
- **Smart Mount Options**: Different mounting strategies based on server OS type
- **Network Resilience**: Multiple fallback options for connecting to SMB shares

## Credits and Resources

The following resources and references were used in the development of this project:

- Internet Archive Collections:
  - NES Collection: https://archive.org/download/nes-collection
  - SNES Collection: https://archive.org/download/SuperNintendofull_rom_pack
  - Genesis Collection: https://archive.org/download/sega-genesis-romset-ultra-usa
  - Game Boy Collection: https://archive.org/download/GameBoy-Romset-by-LoLLo
  - Game Boy Advance Collection: https://archive.org/download/GameboyAdvanceRomCollectionByGhostware
  - Game Boy Color Collection: https://archive.org/download/GameBoyColor
  - Game Gear Collection: https://archive.org/download/sega-game-gear-romset-ultra-us
  - Neo Geo Pocket Collection: https://archive.org/download/neogeopocketromcollectionmm1000
  - Master System Collection: https://archive.org/download/sega-master-system-romset-ultra-us
  - Sega CD Collection: https://archive.org/download/cylums-sega-cd-rom-collection
  - Sega 32X Collection: https://archive.org/download/cylums-sega-32-x-rom-collection
  - Saturn Collection: https://archive.org/download/sega-saturn-romset
  - TurboGrafx-16 Collection: https://archive.org/download/cylums-turbo-grafx-16-rom-collection
  - TurboGrafx-CD Collection: https://archive.org/download/redump.nec_pcecd-tgcd
  - PlayStation Collection: https://archive.org/download/Centuron-PSX
  - PlayStation 2 Collection: https://archive.org/download/asurah94ps2_202405
  - Nintendo 64 Collection: https://archive.org/download/unrenamed-consoles-n64
  - Dreamcast Collection: https://archive.org/download/sega-dreamcast-romset
  - Atari Lynx Collection: https://archive.org/download/AtariLynxRomCollectionByGhostware


## Legal Notice

This script is provided for educational purposes only. Users are responsible for ensuring they have the legal right to download and use any ROMs obtained through this script. The authors do not host or distribute ROMs and are not responsible for the content available through Internet Archive links.
