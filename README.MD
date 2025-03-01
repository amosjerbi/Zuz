# Retrom - Retro Game ROM Manager

Retrom is a powerful shell script utility designed to help you manage and download retro game ROMs from Internet Archive collections.

## Features

- **Interactive Menu System**: Easy-to-use interface for managing your ROM collection
- **Smart Directory Management**: Checks if the default ROM directory exists and offers to create it
- **Multi-Platform Support**: Download ROMs for NES, SNES, Genesis, Game Boy, GBA, Game Gear, Neo Geo Pocket, and Sega Master System
- **Flexible ROM Storage**: Customize where your ROMs are stored or use the default location
- **Search Functionality**: Find specific ROMs across all supported platforms
- **Bulk Downloads**: Download entire ROM collections for any supported platform
- **Directory Verification**: Ensure all ROM directories are properly set up
- **Archive URL Testing**: Verify that all Internet Archive sources are accessible
- **External Storage Support**: Copy your ROM collection to external drives

## Usage

1. Make the script executable:
   ```
   chmod +x Retrom_for_rocknix_v1.sh
   ```

2. Run the script:
   ```
   ./Retrom_for_rocknix_v1.sh
   ```

3. Follow the interactive prompts to manage your ROM collection

## Default ROM Directory

By default, ROMs are stored in `$HOME/Desktop/$(whoami)/games-roms/`
Alternatively, you can customize the location by setting the `ROMS_BASE_DIR` variable in the script or script will ask you to provide path ie:`/Volumes/games-roms/`.
When you run the script:
- If this directory already exists, the script will notify you
- If it doesn't exist, you'll be asked if you want to create it
- You can choose a different location at any time through the menu

## Supported Platforms

| Platform | ROM Directory | Archive Source |
|----------|--------------|----------------|
| NES | nes | Internet Archive NES Collection |
| SNES | snes | Internet Archive SNES Collection |
| Genesis | genesis | Internet Archive Genesis Collection |
| Game Boy | gb | Internet Archive Game Boy Collection |
| Game Boy Advance | gba | Internet Archive GBA Collection |
| Game Gear | gamegear | Internet Archive Game Gear Collection |
| Neo Geo Pocket | ngp | Internet Archive Neo Geo Pocket Collection |
| Sega Master System | mastersystem | Internet Archive Master System Collection |

## Requirements

- Bash shell
- curl (for downloading ROMs)
- Internet connection
- Sufficient disk space for ROM storage

## Legal Notice

This script is provided for educational purposes only. Users are responsible for ensuring they have the legal right to download and use any ROMs obtained through this script. The authors do not host or distribute ROMs and are not responsible for the content available through Internet Archive links.
