# ROMNix - Move your roms from Android, macOS or iOS to handhelds (rocknix,muOS)

Shell script utility designed to help you download game ROMs, obviously you'll need to update your links yourself due to legal reasons. When you use Android version the rom (link provided by yourself) will be downloaded to android and then transferred to rocknix/Lakka if such is available.

## Features:

- **Broad search**: You can search across all platforms and download them all@ 
- **Download all from search query**: You can now search and to download them all each ROM will be saved to their right platform folder
- **Dynamic IP addresses**: Go to 1.Scan for SMB hosts Which will scan your active IPs
- **Multiple transfers**: Transfer in one click the same game to multiple devices (If SMB IPs were detected)
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
   chmod +x archiveorg.sh (drag file to Terminal)
   ```
2. Run the script on macOS (drag to Terminal):
   ```
   ./archiveorg.sh

   ```
## Usage on Android

1. Download Termux
2. Open archiveorg.sh on Termux
3. Run the script on Termux (Android):
   ```
   bash archiveorg.sh

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

## Create a shorcut

🟡 Step 1: Open Termux (download from Play Store)

🟡 Step 2: Open your shell config file
   ```
nano ~/.bashrc
   ```

🟡Step 3: Add your alias
New window will open add this line:
   ```
alias romnix='bash /storage/emulated/0/Download/archiveorg.sh'
   ```
Replace romnix with whatever name you want to type, and the path with your actual script.

🟡 Step 4: Save and reload
1. Press CTRL then X (there's a CTRL button abouve keyboard)
2. Press Y
3. Press Enter to save and exit

Then reload the file:
   ```
source ~/.bashrc
   ```

✅ Step 5: Run it
Now just type:
   ```
romnix
   ```
…and your script runs!

## Create a widget (dependant on 'create a shortcut')
Steps:
Long-press the Termux app icon on your home screen.

1. Tap “Widgets” in the menu that pops up.
2. Drag the “Termux Shortcut” (1x1 widget) onto your home screen.
3. It will open a list of scripts from your storage.
4. Navigate to and select your script (romnix)
5. Done! Now you can activate screen in one tap! 🎉

## Legal Notice

This script is provided for educational purposes only. Users are responsible for ensuring they have the legal right to download and use any ROMs obtained through this script. The authors do not host or distribute ROMs and are not responsible for the content users inject to code.
