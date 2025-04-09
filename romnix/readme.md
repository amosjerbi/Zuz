# ROMNix - RockNix ROM Management Tool

## Overview
ROMNix is a shell script designed to automate the process of finding, downloading, and managing ROMs for the RockNix gaming system. The script searches for ROMs based on user-defined search terms and downloads them to the appropriate platform-specific directories.

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

## Usage

### Basic Usage
1. Edit the script to set your desired platform and search terms
2. Run the script:
   ```
   chmod +x romnix.sh
   ./romnix.sh
   ```

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
