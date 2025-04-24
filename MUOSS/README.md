# ROMNix - RockNix ROM Management Tool

## Overview
ROMNix is a shell script that runs directly on rocknix from ports folder.
It automates the process of finding, downloading, and managing ROMs for the Rocknix gaming system. The script searches for ROMs based on pre-defined search terms and downloads them to the appropriate platform-specific directories.

## Usage

### Basic Usage
1. Edit the script to set your desired platform and search terms & URLs
2. Copy script to ports folder in rocknix and run it locally from device!
3. Screen will go black till all roms are downloaded then kick you to menu
4. Press start -> Game Settings -> Update Gamelists
5. All your roms should be at their appropriate folder 🎉
---
Alternatively, run script from terminal on macOS to see if it works

## Configuration
The script can be configured by modifying the following variables:
- `PLATFORM`: Set the target platform (e.g., "nes", "snes", "gba")
- `SEARCH_TERMS`: Add search terms to find specific ROMs
- `URLS`: List of mirror URLs to search for ROMs

## Features
- Automated ROM searching and downloading
- Platform-specific organization (NES, SNES, etc.)
- Configurable search terms
- Multiple source URL support
- Automatic directory creation

## Prerequisites
- SSH access to your RockNix device
- `sshpass` installed on your system (for automated transfers)
- Basic shell scripting knowledge for customization

## Directory Structure
- RockNix ROM path: `$HOME/games-internal/roms/[PLATFORM]`
- Local ROM path: `$HOME/desktop/roms/[PLATFORM]`
- Android ROM path: '/storage/emulated/0/Download/roms/'

### Transferring ROMs to RockNix
After downloading ROMs, transfer them to your RockNix device:

```bash
sshpass -p 'rocknix' scp -o StrictHostKeyChecking=no [ROM_FILE] root@[ROCKNIX_IP]:/storage/roms/[PLATFORM]/
```

Replace:
- `[ROM_FILE]` with the path to your ROM file
- `[ROCKNIX_IP]` with your RockNix device's IP address
- `[PLATFORM]` with the appropriate platform folder

## RockNix System Information
- Default user: root
- Default password: rocknix
- Cores path: `/storage/cores/`
- ROMs path: `/storage/roms/`

## Tips
- Use network scanning to discover your RockNix device's IP address
- Create platform-specific directories under the local ROMs folder
- For larger collections, consider organizing ROMs alphabetically

## Customization
The script can be easily modified to:
- Add more platforms
- Change download locations
- Implement additional filtering
- Add post-download processing

## License
This script is open source and available for use and modification.
