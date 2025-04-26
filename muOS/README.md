# ROMnix Manager

A utility tool donwnloading roms directly from your device in MUOS (MustardOS)

## Prerequisites

1. Rename ROMnix_Manager.muxzip to ROMnix_Manager.zip
2. Extract ROMnix_Manager.zip
3. Edit romnix.sh inside ROMnix_Manager folder
4. Find in the script /PUT_DIRECTORY_HERE and replace it with the correct directory (I don't support piracy).
5. Once done save romnix.sh and create a new zip file from the mnt folder
6. Rename the new zip file to ROMnix_Manager.muxzip (in terminal)

```
mv ROMnix_Manager.zip ROMnix_Manager.muxzip
```

## Installation

1. Connect to your MUOS device by usb-c cable or going to (your IP address):9090 (Port) (user:muos, pass:muos)
2. Copy ROMnix_Manager.muxzip to Home > SD1 (mmc) > ARCHIVE
3. On your device activate the ROMnix_Manager.muxzip from Application menu
4. After successfully installing, you can use ROMnix Manager from the menu 🎉

## Features

- Vanilla code without piracy links
- Create appropriate folders by platform (NES, SNES, etc.) if it doesn't exist
- All downloads happens witin MUOS (MustardOS) environment using Simple Terminal app

## Project Structure

The ROMnix_Manager.muxzip contains the following structure:

```
ROMnix_Manager.muxzip/
├── mnt/
│   ├── mmc/
│   │   └── MUOS/
│   │       ├── application/
│   │       │   └── ROMnix Manager/
│   │       │       ├── romnix.sh                                     # Main script for ROM management
│   │       │       ├── res folder (SourceCodePro-Regular.ttf)        # Contains font for icon
│   │       │       ├── terminal.sh                                   # Terminal script
│   │       │       └── mux_launch.sh.png                             # Launch script

```
