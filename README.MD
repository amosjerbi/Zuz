# Zuz - Move your roms from Phone & macOS to handhelds

Zuz (means move in Hebrew) is a shell script utility designed to help you download game ROMs, obviously you'll need to update your links yourself due to legal reasons. When you use Android version the rom (link provided by yourself) will be downloaded to android and then transferred to rocknix/Lakka if such is available.

## Features:

- **Dynamic IP addresses**: Go to 1.Scan for SMB hosts Which will scan your active IPs
- **Multiple transfers**: Transfer in one click the same game to multiple devices (If SMB IP were detected)
- **Modified Menu**: All platforms are shown first and options like open directory and SMB are in 'More Options'
- **Links**: The root of the link is the same to all (archive.org) but haven't specified directories, that on you to fill in :)
- **SMB Network Support**: Connect to SMB shares on your local network to access ROMs
- **Multi-OS Compatibility**: Optimized SMB mounting for MacOS, Windows, and Linux servers & Android
- **Network Auto-Discovery**: Automatic scanning for SMB servers on your local network

## Before you run scripts

Check the links, you'll need the right archive.org directories per platform:
```
 "$base_url/PUT_DIRECTORY_HERE";;
```

## Usage on Mac

1. Make the script executable:
   ```
   chmod +x zuz.sh (drag file to Terminal)
   ```
2. Run the script on macOS (drag to Terminal):
   ```
   ./zuz.sh

   ```
## Usage on Android

1. Download Termux
2. Open zuz.sh on Termux
3. Run the script on Termux (Android):
   ```
   bash zuz.sh

   ```
4. All the platforms will be listed
   
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

## Supported Platforms (I don't provide ROM links this one is on you!)

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
- Termux - An app for Android (available for free on Play Store) 
- Internet connection
- Sufficient disk space

## Legal Notice

This script is provided for educational purposes only. Users are responsible for ensuring they have the legal right to download and use any ROMs obtained through this script. The authors do not host or distribute ROMs and are not responsible for the content users inject to code.
