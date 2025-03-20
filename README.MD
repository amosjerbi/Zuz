# Retrom - Retro Game ROM Manager

Retrom is a shell script utility designed to help you manage and download retro game ROMs, obviously you'll need to update your links yourself due to legal reasons it's pretty straight forward. When you use Android version the rom (link provided by yourself) will be downloaded to device and then transferred to rocknix if such is available (change the IP if needed in code).

## Version 2 Updates

Version 3 introduces significant new features:

- **Modified Menu**: All platforms are shown first and options like open directory and SMB are in 'More'
- **Links**: The root of the link is the same to all (archive.org) but haven't specified directories, that on you to fill in :)
- **SMB Network Support**: Connect to SMB shares on your local network to access ROMs
- **Multi-OS Compatibility**: Optimized SMB mounting for MacOS, Windows, and Linux servers & Android
- **Network Auto-Discovery**: Automatic scanning for SMB servers on your local network
- **Improved Directory Management**: Enhanced handling of ROM directories with network support

## Before you run scripts

Check the links, you'll need the right archive.org directories:
```
lakka_android.sh - Run this on Android and it'll copy roms TO Lakka 
rocknix_android.sh - Run this on Android and it'll copy roms TO Rocknix
```

```
lakka_mac.sh - Drag to terminal window on macOS and it'll copy TO Lakka 
rocknix_mac.sh - Drag to terminal window on macOS and it'll copy TO Rocknix
```


## Usage on Mac

1. Make the script executable:
   ```
   chmod +x lakka_mac.sh
   chmod +x rocknix_mac.sh
   ```
2. Run the script on macOS (drag to Terminal):
   ```
   ./rocknix_mac.sh
   ./lakka_mac.sh
   ```
## Usage on Android

1. Download Termux
2. Open lakka_mac.sh or rocknix_mac.sh on Termux
3. Run the script on Termux (Android):
   ```
   bash rocknix_android.sh
   bash lakka_android.sh
   ```
4. All the platforms will be listed
   
   You can also specify a custom ROM directory (on your desktop for example):
   ```
   DEFAULT_ROMS_BASE_DIR="$HOME/Desktop/$(whoami)/games-roms"
   ```

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
- **External Storage Support**: Copy your ROM collection to external drives
- **Selection and Highlighting**: Ability to highlight and select items for better visual feedback and interaction
- **Network SMB Support**: Connect to SMB shares on your local network
- **Auto-Discovery**: Automatically scan and find SMB servers on your network
- **Multi-OS Compatibility**: Optimized mounting for MacOS, Windows, and Linux SMB servers
- **Smart Mount Options**: Different mounting strategies based on server OS type
- **Network Resilience**: Multiple fallback options for connecting to SMB shares


## Legal Notice

This script is provided for educational purposes only. Users are responsible for ensuring they have the legal right to download and use any ROMs obtained through this script. The authors do not host or distribute ROMs and are not responsible for the content users inject to code.
