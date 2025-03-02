# Retrom - Retro Game ROM Manager

Retrom is a shell script utility designed to help you manage and download retro game ROMs from Internet Archive collections, obviously you'll need to update your links yourself due to legal reasons.

## Usage

1. Make the script executable:
   ```
   chmod +x Retrom_for_rocknix_v1.sh
   ```

2. Run the script:
   ```
   ./Retrom_v1.sh
   ```

3. Follow the interactive prompts to manage your ROM collection

## Default ROM Directory

When you run the script:
- If this directory already exists, the script will notify you
- If it doesn't exist, you'll be asked if you want to create it
- You can choose a different location at any time through the menu

By default, ROMs are stored in
   ```
`$HOME/Desktop/$(whoami)/games-roms/`
   ```
Alternatively, the script will ask you if you want another target location. Like in Rocknix for example:
   ```
`/Volumes/games-roms/`
   ```

you can also customize the location by setting the `ROMS_BASE_DIR` variable in the script.

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


## Legal Notice

This script is provided for educational purposes only. Users are responsible for ensuring they have the legal right to download and use any ROMs obtained through this script. The authors do not host or distribute ROMs and are not responsible for the content available through Internet Archive links.
