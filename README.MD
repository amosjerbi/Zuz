# Retro Game ROM Manager

This repository contains scripts for managing and downloading retro game ROMs from Internet Archive collections.

## Scripts Overview

### 1. `works_forpath_mac_v1.sh`

A shell script designed for macOS systems that provides a command-line interface for:
- Searching and downloading retro game ROMs from Internet Archive collections
- Managing ROM directories for various gaming platforms (NES, SNES, Genesis, Game Boy, etc.)
- Verifying ROM directories and testing archive URLs
- Organizing ROMs in a structured directory hierarchy

This script stores ROMs in a directory structure under `$HOME/Desktop/$(whoami)/games-roms/`.

### 2. `works_forpath_rocknix_v1.sh`

A variant of the ROM manager script optimized for RockNix systems (a Linux-based OS for retro gaming). This script includes:
- All the functionality of the macOS version
- Additional features for handling external drives
- Enhanced ROM management capabilities specific to RockNix
- Ability to copy ROMs to external storage

This script stores ROMs in a directory structure under `/Volumes/games-roms/`.

## Supported Platforms

Both scripts support the following retro gaming platforms:
- Nintendo Entertainment System (NES)
- Super Nintendo Entertainment System (SNES)
- Sega Genesis
- Game Boy (GB)
- Game Boy Advance (GBA)
- Sega Game Gear
- Neo Geo Pocket
- Sega Master System

## Features

- **Platform Selection**: Choose which gaming platform to work with
- **ROM Search**: Search for specific ROMs by name
- **ROM Download**: Download individual ROMs or entire collections
- **Directory Management**: Automatically create and verify ROM directories
- **URL Testing**: Test archive URLs to ensure they're accessible
- **External Storage Support** (RockNix version): Copy ROMs to external drives

## Usage

1. Make the script executable:
   ```
   chmod +x works_forpath_mac_v1.sh
   ```
   or
   ```
   chmod +x works_forpath_rocknix_v1.sh
   ```

2. Run the script:
   ```
   ./works_forpath_mac_v1.sh
   ```
   or
   ```
   ./works_forpath_rocknix_v1.sh
   ```

3. Follow the interactive menu to select options for managing your ROM collection

## Requirements

- Bash shell
- curl (for downloading ROMs)
- Internet connection
- Sufficient disk space for ROM storage

## Legal Notice

These scripts are provided for educational purposes only. Users are responsible for ensuring they have the legal right to download and use any ROMs obtained through these scripts. The authors do not host or distribute ROMs and are not responsible for the content available through Internet Archive links.
