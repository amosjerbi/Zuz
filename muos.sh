#!/bin/bash

# Set variables
CURRENT_PLATFORM=""
ROMS_ROOT="/mnt/mmc/ROMS"  # Local ROMs storage path
ROCKNIX_USER="root"
ROCKNIX_PASS="rocknix"  # Primary RockNix password
ROCKNIX_PASS_ALT="root" # Alternative RockNix password
LAKKA_USER="lakka"      # Lakka user
LAKKA_PASS="root"       # Lakka password
ROCKNIX_ROMS_PATH="/mnt/mmc/ROMS"  # RockNix storage path
DETECTED_SMB_HOSTS=(192.168.0.101)  # Array to store detected SMB hosts

# Platform-specific directories using the base variable
NES_DIR="$ROMS_ROOT/nes"
SNES_DIR="$ROMS_ROOT/snes"
GENESIS_DIR="$ROMS_ROOT/genesis"
GB_DIR="$ROMS_ROOT/gb"
GBA_DIR="$ROMS_ROOT/gba"
GBC_DIR="$ROMS_ROOT/gbc"
GAMEGEAR_DIR="$ROMS_ROOT/gamegear"
NGP_DIR="$ROMS_ROOT/ngp"
SMS_DIR="$ROMS_ROOT/mastersystem"
SEGACD_DIR="$ROMS_ROOT/segacd"
SEGA32X_DIR="$ROMS_ROOT/sega32x"
SATURN_DIR="$ROMS_ROOT/saturn"
TG16_DIR="$ROMS_ROOT/tg16"
TGCD_DIR="$ROMS_ROOT/tgcd"
PS1_DIR="$ROMS_ROOT/psx"
PS2_DIR="$ROMS_ROOT/ps2"
N64_DIR="$ROMS_ROOT/n64"
LYNX_DIR="$ROMS_ROOT/lynx"
TEMP_FILE="/mnt/mmc/ROMS/temp_rom_list.txt"
SMB_MOUNT_DIR="/mnt/mmc/ROMS"

# Function to decode URL-encoded strings
urldecode() {
    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}

# Function to convert to uppercase
to_uppercase() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

# Function to get archive URL for a platform
get_archive_url() {
    local platform="$1"
    local base_url="https://archive.org/download"
    
  # Map platform to archive URL
    case "$platform" in
        "nes") echo "$base_url/nes-collection";;
        "snes") echo "$base_url/SuperNintendofull_rom_pack";;
        "genesis") echo "$base_url/sega-genesis-romset-ultra-usa";;
        "gb") echo "$base_url/game-boy-collection";;
        "gba") echo "https://ia600307.us.archive.org/view_archive.php?archive=/4/items/super-card-top-151-gba/SuperCard%20Top%20151%20GBA%20roms.zip";;
        "gbc") echo "$base_url/GameBoyColor";;
        "gamegear") echo "$base_url/sega-game-gear-romset-ultra-us";;
        "ngp") echo "$base_url/neogeopocketromcollectionmm1000";;
        "sms") echo "$base_url/sega-master-system-romset-ultra-us";;
        "segacd") echo "$base_url/cylums-sega-cd-rom-collection/Cylum%27s%20Sega%20CD%20ROM%20Collection%20%2802-19-2021%29/";;
        "sega32x") echo "$base_url/Sega32XROMs";;
        "saturn") echo "$base_url/ef_Sega_Saturn_Collection/Sega%20Saturn/";;
        "tg16") echo "$base_url/TurboGrafx16ROMs_201901";;
        "tgcd") echo "$base_url/redump.nec_pcecd-tgcd";;
        "ps1") echo "$base_url/Centuron-PSX";;
        "neogeo") echo "$base_url/neogeoaesmvscomplete/Neo%20Geo%20AES%20-%20MVS/Geolith%20romset/MAME%20Based/";;
        "n64") echo "$base_url/unrenamed-consoles-n64/UnRenamed%20Consoles%20-%20NINTENDO-N64";;
        "lynx") echo "$base_url/AtariLynxRomCollectionByGhostware";;
        *) echo "";;
    esac
}

# Function to get platform directory
get_platform_dir() {
    local platform="$1"
    local base_dir="/mnt/mmc/ROMS"  # Mac Desktop ROMs folder
    
    # Map platform name to directory name
    case "$platform" in
        "nes") echo "$base_dir/nes";;
        "snes") echo "$base_dir/snes";;
        "genesis") echo "$base_dir/genesis";;
        "gb") echo "$base_dir/gb";;
        "gba") echo "$base_dir/gba";;
        "gbc") echo "$base_dir/gbc";;
        "gamegear") echo "$base_dir/gamegear";;
        "ngp") echo "$base_dir/ngp";;
        "sms") echo "$base_dir/mastersystem";;
        "segacd") echo "$base_dir/segacd";;
        "sega32x") echo "$base_dir/sega32x";;
        "saturn") echo "$base_dir/saturn";;
        "tg16") echo "$base_dir/tg16";;
        "tgcd") echo "$base_dir/tgcd";;
        "ps1") echo "$base_dir/psx";;
        "ps2") echo "$base_dir/ps2";;
        "n64") echo "$base_dir/n64";;
        "lynx") echo "$base_dir/lynx";;
        *) echo "$base_dir/$platform";;
    esac
}

# Create base directory if it doesn't exist
mkdir -p "$ROMS_ROOT"

# Create SMB mount directory if it doesn't exist
mkdir -p "$SMB_MOUNT_DIR"

# We'll focus on using the storage/roms path for all mounts

# Note: We'll use user's home directory for all mounts to avoid requiring admin privileges

# Function to open the ROMs folder
open_roms_folder() {
    # Get the platform subdirectory name
    local platform_subdir=""
    case "$CURRENT_PLATFORM" in
        "nes") platform_subdir="nes" ;;
        "snes") platform_subdir="snes" ;;
        "genesis") platform_subdir="genesis" ;;
        "gb") platform_subdir="gb" ;;
        "gba") platform_subdir="gba" ;;
        "gbc") platform_subdir="gbc" ;;
        "gamegear") platform_subdir="gamegear" ;;
        "ngp") platform_subdir="ngp" ;;
        "sms") platform_subdir="mastersystem" ;;
        "segacd") platform_subdir="segacd" ;;
        "sega32x") platform_subdir="sega32x" ;;
        "saturn") platform_subdir="saturn" ;;
        "tg16") platform_subdir="tg16" ;;
        "tgcd") platform_subdir="tgcd" ;;
        "ps1") platform_subdir="ps1" ;;
        "ps2") platform_subdir="ps2" ;;
        "n64") platform_subdir="n64" ;;
        "lynx") platform_subdir="lynx" ;;
        "lynx") platform_subdir="lynx" ;;
        *) platform_subdir="$CURRENT_PLATFORM" ;;
    esac
    
    # Use the ROMS_ROOT directory
    local platform_dir="$ROMS_ROOT/$platform_subdir"
    
    # Create the directory if it doesn't exist
    mkdir -p "$platform_dir"
    
    echo "Opening ROMs folder for platform: $(to_uppercase $CURRENT_PLATFORM)"
    echo "Directory: $platform_dir"
    
    # Open the directory based on the OS
    case "$(uname)" in
        "Darwin") # macOS
            open "$platform_dir"
            ;;
        "Linux")
            if command -v xdg-open > /dev/null; then
                xdg-open "$platform_dir"
            else
                echo "Cannot open directory. xdg-open not found."
                return 1
            fi
            ;;
        "MINGW"*|"MSYS"*|"CYGWIN"*) # Windows
            explorer "$platform_dir"
            ;;
        *)
            echo "Unsupported operating system for opening directories."
            return 1
            ;;
    esac
}

# Function to handle arrow key navigation and numeric selection
menu_select() {
    local options=("$@")
    local num_options=${#options[@]}
    local selected=0
    local key

   # Function to draw menu
    draw_menu() {
        # Clear screen for Android compatibility
        clear
        
        for i in $(seq 0 $((num_options-1))); do
            if [ $i -eq $selected ]; then
                printf "\033[7m> %2d. %s\033[0m\n" $((i+1)) "${options[$i]}"  # Highlighted with number
            else
                printf "  %2d. %s\n" $((i+1)) "${options[$i]}"  # With number
            fi
        done
    }

    # Draw initial menu
    draw_menu

    # Handle keypresses
    while true; do
        read -rsn1 key

        # Check if key is a number
        if [[ $key =~ [0-9] ]]; then
            # Start collecting digits for multi-digit numbers
            local number=$key
            local timeout=0.5  # Timeout in seconds
            
            # Set up a timeout for reading additional digits
            read -rsn1 -t $timeout next_key
            while [[ $? -eq 0 && $next_key =~ [0-9] ]]; do
                number="${number}${next_key}"
                read -rsn1 -t $timeout next_key
            done
            
            # Convert to integer and check if it's valid
            number=$((10#$number))  # Force base 10 interpretation
            
            if [ $number -ge 1 ] && [ $number -le $num_options ]; then
                # No need for cursor movement on Android
                echo
                return $number
            fi
            
            # If invalid number, just redraw the menu
            draw_menu
            continue
        fi

        case "$key" in
            $'\x1b')  # ESC sequence
                read -rsn2 key
                case "$key" in
                    '[A')  # Up arrow
                        if [ $selected -gt 0 ]; then
                            selected=$((selected-1))
                            draw_menu
                        fi
                        ;;
                    '[B')  # Down arrow
                        if [ $selected -lt $((num_options-1)) ]; then
                            selected=$((selected+1))
                            draw_menu
                        fi
                        ;;
                esac
                ;;
            '')  # Enter key
                echo
                return $((selected+1))
                ;;
        esac
    done
}

# Function to select a platform
select_platform() {
    clear
    echo "Select a platform:"
    echo "-----------------------------------------------------"
    echo "You can use ↑↓ arrows and Enter, or directly type a number (1-19)"
    echo "-----------------------------------------------------"
    
    local platforms=(
        "NES (Nintendo Entertainment System)"
        "SNES (Super Nintendo)"
        "GB (Game Boy)"
        "GBA (Game Boy Advance)"
        "GBC (Game Boy Color)"
        "SMS (Sega Master System)"
        "Genesis (Sega Genesis)"
        "SEGACD (Sega CD)"
        "SEGA32X (Sega 32X)"
        "SATURN (Sega Saturn)"
        "gamegear (Sega Game Gear)"
        "NGP (Neo Geo Pocket)"
        "TG16 (TurboGrafx-16)"
        "TGCD (TurboGrafx-CD)"
        "PS1 (PlayStation)"
        "PS2 (PlayStation 2)"
        "N64 (Nintendo 64)"
        "lynx (Sega lynx)"
        "LYNX (Atari Lynx)"
    )
    
    echo "Select a platform:"
    echo "-----------------------------------------------------"
    menu_select "${platforms[@]}"
    platform_choice=$?
    
    case $platform_choice in
        1)
            CURRENT_PLATFORM="nes"
            echo "Selected platform: NES"
            ;;
        2)
            CURRENT_PLATFORM="snes"
            echo "Selected platform: SNES"
            ;;
        3)
            CURRENT_PLATFORM="gb"
            echo "Selected platform: Game Boy"
            ;;
        4)
            CURRENT_PLATFORM="gba"
            echo "Selected platform: Game Boy Advance"
            ;;
        5)
            CURRENT_PLATFORM="gbc"
            echo "Selected platform: Game Boy Color"
            ;;
        6)
            CURRENT_PLATFORM="sms"
            echo "Selected platform: Sega Master System"
            ;;
        7)
            CURRENT_PLATFORM="genesis"
            echo "Selected platform: Genesis"
            ;;
        8)
            CURRENT_PLATFORM="segacd"
            echo "Selected platform: Sega CD"
            ;;
        9)
            CURRENT_PLATFORM="sega32x"
            echo "Selected platform: Sega 32X"
            ;;
        10)
            CURRENT_PLATFORM="saturn"
            echo "Selected platform: Sega Saturn"
            ;;
        11)
            CURRENT_PLATFORM="gamegear"
            echo "Selected platform: Sega Game Gear"
            ;;
        12)
            CURRENT_PLATFORM="ngp"
            echo "Selected platform: Neo Geo Pocket"
            ;;
        13)
            CURRENT_PLATFORM="tg16"
            echo "Selected platform: TurboGrafx-16"
            ;;
        14)
            CURRENT_PLATFORM="tgcd"
            echo "Selected platform: TurboGrafx-CD"
            ;;
        15)
            CURRENT_PLATFORM="ps1"
            echo "Selected platform: PlayStation"
            ;;
        16)
            CURRENT_PLATFORM="ps2"
            echo "Selected platform: PlayStation 2"
            ;;
        17)
            CURRENT_PLATFORM="n64"
            echo "Selected platform: Nintendo 64"
            ;;
        18)
            CURRENT_PLATFORM="lynx"
            echo "Selected platform: Sega lynx"
            ;;
        19)
            CURRENT_PLATFORM="lynx"
            echo "Selected platform: Atari Lynx"
            ;;
        *)
            echo "Invalid choice. Using default platform: Genesis"
            CURRENT_PLATFORM="genesis"
            ;;
    esac
}

# Function to detect OS type
detect_os_type() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "MacOS"
    elif [[ "$OSTYPE" == "linux-android"* ]] || command -v termux-setup-storage >/dev/null 2>&1; then
        echo "Android"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "Linux"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        echo "Windows"
    else
        echo "Unknown"
    fi
}

# Function to detect and connect to SMB
detect_and_connect_smb() {
    # Detect current OS
    CURRENT_OS=$(detect_os_type)
    echo "Current OS: $CURRENT_OS"

    # Display connection options menu
    local connection_options=(
        "MacOS - Scan & mount SMB"
        "Windows - Scan & mount SMB"
        "Linux - Scan & mount SMB"
        "Android - Scan & mount SMB"
        "Enter SMB address manually"
        "Return to main menu"
    )
    
    echo "Select a connection option:"
    echo "-----------------------------------------------------"
    menu_select "${connection_options[@]}"
    local connection_choice=$?
    
    # Handle the selected option
    case $connection_choice in
        1|2|3|4) # Scan network (MacOS, Windows, Linux, or Android)
            clear
            local os_type=""
            if [ "$connection_choice" -eq 1 ]; then
                echo "===== Scanning Network for MacOS SMB Servers ====="
                os_type="MacOS"
            elif [ "$connection_choice" -eq 2 ]; then
                echo "===== Scanning Network for Windows SMB Servers ====="
                os_type="Windows"
            elif [ "$connection_choice" -eq 3 ]; then
                echo "===== Scanning Network for Linux SMB Servers ====="
                os_type="Linux"
            elif [ "$connection_choice" -eq 4 ]; then
                echo "===== Scanning Network for Android SMB Servers ====="
                os_type="Android"
            fi
            
            # Create temporary files for storing SMB shares
            local smb_list_file=$(mktemp)
            
            # Get the local IP and subnet
            local ip_info=$(ifconfig | grep "inet " | grep -v 127.0.0.1)
            local ip_addr=$(echo "$ip_info" | awk '{print $2}')
            local subnet=$(echo "$ip_addr" | cut -d. -f1-3)
            
            echo "Your IP address: $ip_addr"
            echo "Scanning subnet: $subnet.x"
            echo "Looking for $os_type SMB servers..."
            
            # Quick scan of common IP addresses
            echo "Scanning common IP addresses..."
            
            # Common IP ranges for routers and servers
            common_ips=("1" "100" "101" "102" "103" "104" "105" "110" "120" "130" "132" "150" "200" "201" "202" "254")
            
            # Scan the common IPs first (faster)
            for i in "${common_ips[@]}"; do
                echo -n "."
                ping -c 1 -W 1 "$subnet.$i" &> /dev/null && echo "$subnet.$i" >> "$smb_list_file" &
            done
            wait
            echo " Done!"
            
            # Create a list of SMB hosts
            local smb_hosts=()
            
            # Sort and remove duplicates from the list
            sort -u "$smb_list_file" > "${smb_list_file}.sorted"
            mv "${smb_list_file}.sorted" "$smb_list_file"
            
            # Check all discovered hosts
            echo "Checking discovered hosts..."
            while IFS= read -r ip; do
                # Skip empty lines
                if [ -z "$ip" ]; then
                    continue
                fi
                
                echo -n "Checking $ip... "
                
                # Check if the host responds to SMB port (TCP 445 or 139) with a short timeout
                if nc -z -G 1 "$ip" 445 2>/dev/null || nc -z -G 1 "$ip" 139 2>/dev/null; then
                    echo "SMB service found!"
                    
                    # Try to get hostname (quick lookup)
                    local hostname=$(dscacheutil -q host -a ip_address "$ip" 2>/dev/null | grep "name" | head -1 | awk '{print $2}')
                    
                    if [ -z "$hostname" ] || [ "$hostname" = "$ip" ]; then
                        smb_hosts+=("$ip (SMB)")
                    else
                        smb_hosts+=("$hostname ($ip) (SMB)")
                    fi
                else
                    echo "No SMB service detected."
                fi
            done < "$smb_list_file"
            
            # Check if any SMB hosts were found
            if [ ${#smb_hosts[@]} -eq 0 ]; then
                echo "No SMB servers found on the network."
                echo "Adding $ROCKNIX_HOST as a fallback option."
                smb_hosts+=("$ROCKNIX_HOST (Known SMB Server)")
            fi
            
            # Add return option
            smb_hosts+=("Return to connection menu")
            
            # Display the list of hosts
            clear
            echo "===== SMB Servers Found ====="
            echo "Select a host to connect to:"
            echo "-----------------------------------------------------"
            
            menu_select "${smb_hosts[@]}"
            local host_choice=$?
            
            # Check if user selected the return option
            if [ "$host_choice" -eq ${#smb_hosts[@]} ]; then
                # Return to the beginning of the function
                detect_and_connect_smb
                return 0
            fi
            
            # Extract IP from selection (which might include hostname)
            selected_host=$(echo "${smb_hosts[$((host_choice-1))]}" | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' || echo "${smb_hosts[$((host_choice-1))]}")
            # Keep the OS type from the menu selection
            # os_type is already set above
            ;;
        4) # Manual entry
            read -p "Enter SMB address (e.g., 192.168.1.100 or server.local): " manual_host
            if [ -z "$manual_host" ]; then
                echo "No address entered. Returning to main menu..."
                sleep 2
                return 0
            fi
            selected_host="$manual_host"
            
            # For manual entry, ask for OS type
            clear
            echo "Select the operating system type of the SMB server:"
            local os_options=("MacOS" "Windows" "Linux" "Android" "Unknown/Other")
            menu_select "${os_options[@]}"
            local os_choice=$?
            
            case $os_choice in
                1) os_type="MacOS" ;;
                2) os_type="Windows" ;;
                3) os_type="Linux" ;;
                4) os_type="Android" ;;
                5) os_type="" ;; # Unknown/Other
            esac
            ;;
        5) # Return to main menu
            echo "Returning to main menu..."
            return 0
            ;;
    esac
    

    
    # Now try to list shares on the selected host
    echo "Attempting to list shares on $selected_host..."
    
    # Create temporary file for storing shares
    local shares_list_file=$(mktemp)
    
    # Try to list shares using smbutil with better parsing
    echo "Trying to list shares on $selected_host..."
    
    # First attempt - try with guest access
    smbutil view "//$selected_host" 2>/dev/null > "${shares_list_file}.raw"
    
    # If that fails, try with -g for guest access explicitly
    if [ ! -s "${shares_list_file}.raw" ]; then
        echo "Retrying with explicit guest access..."
        smbutil view -g "//$selected_host" 2>/dev/null > "${shares_list_file}.raw"
    fi
    
    # Process the raw output to extract share names and comments
    if [ -s "${shares_list_file}.raw" ]; then
        # Skip header lines and extract share names and comments
        cat "${shares_list_file}.raw" | grep -v "WORKGROUP\|-----" | tail -n +2 | while read -r line; do
            # Extract share name (first column) and comment (if available)
            share_name=$(echo "$line" | awk '{print $1}')
            share_comment=$(echo "$line" | cut -d' ' -f2- | sed 's/^[[:space:]]*//')
            
            if [ -n "$share_name" ] && [ "$share_name" != "Disk" ]; then
                if [ -n "$share_comment" ] && [ "$share_comment" != "Disk" ]; then
                    echo "$share_name ($share_comment)" >> "$shares_list_file"
                else
                    echo "$share_name" >> "$shares_list_file"
                fi
            fi
        done
    else
        # If we still can't get shares, try a direct approach for common share names
        echo "Unable to list shares. Trying common share names..."
        echo "ROMS" >> "$shares_list_file"
        echo "roms" >> "$shares_list_file"
        echo "games" >> "$shares_list_file"
        echo "games-roms" >> "$shares_list_file"
        echo "share" >> "$shares_list_file"
    fi
    
    # Debug output
    echo "Found shares:"
    cat "$shares_list_file"
    
    # Read the shares into an array
    local smb_shares=()
    
    # Sort and remove duplicates from the list
    sort -u "$shares_list_file" > "${shares_list_file}.sorted"
    mv "${shares_list_file}.sorted" "$shares_list_file"
    
    # Check all discovered hosts
    echo "Checking discovered hosts..."
    while IFS= read -r share; do
        # Skip empty lines
        if [ -z "$share" ]; then
            continue
        fi
        
        echo -n "Checking $share... "
        
        # Check if the host responds to SMB port (TCP 445 or 139) with a short timeout
        if nc -z -G 1 "$selected_host" 445 2>/dev/null || nc -z -G 1 "$selected_host" 139 2>/dev/null; then
            echo "SMB service found!"
            
            # Try to get hostname (quick lookup)
            local hostname=$(dscacheutil -q host -a ip_address "$selected_host" 2>/dev/null | grep "name" | head -1 | awk '{print $2}')
            
            if [ -z "$hostname" ] || [ "$hostname" = "$selected_host" ]; then
                smb_shares+=("$selected_host (SMB)")
            else
                smb_shares+=("$hostname ($selected_host) (SMB)")
            fi
        else
            echo "No SMB service detected."
        fi
    done < "$shares_list_file"
    
    # Check if any SMB hosts were found
    if [ ${#smb_shares[@]} -eq 0 ]; then
        echo "No SMB servers found on the network."
        echo "Adding $ROCKNIX_HOST as a fallback option."
        smb_shares+=("$ROCKNIX_HOST (Known SMB Server)")
    fi
    
    # Add return option
    smb_shares+=("Return to connection menu")
    
    # Display the list of shares
    clear
    echo "===== Available SMB Shares on $selected_host ====="
    echo "Select a share to connect to:"
    echo "-----------------------------------------------------"
    
    # Print a message about what these shares are
    echo "These are the shared folders available on the SMB server."
    echo "Select the one containing your ROM files."
    echo "-----------------------------------------------------"
    
    menu_select "${smb_shares[@]}"
    local share_choice=$?
    
    # Check if user selected the return option
    if [ "$share_choice" -eq ${#smb_shares[@]} ]; then
        echo "Returning to main menu..."
        return 0
    fi
    
    local selected_share="${smb_shares[$((share_choice-1))]}"
    
    # Extract just the share name without any description
    local clean_share=$(echo "$selected_share" | cut -d' ' -f1)
    echo "Selected share: $clean_share"
    
    # Determine the mount point based on the share type
    local mount_point
    local is_rom_share=false
    
    # Check if this is a ROM share
    if [[ "$clean_share" == "games-roms" || "$clean_share" == "games-rom" || "$clean_share" == "roms" || "$clean_share" == "games" ]]; then
        is_rom_share=true
        # For ROM shares, use $HOME/smb-mount/games-roms
        mount_point="$SMB_MOUNT_DIR/games-roms"
    else
        # For non-ROM shares, use $HOME/smb-mount/[share-name]
        mount_point="$SMB_MOUNT_DIR/$clean_share"
    fi
    
    echo "Mount point: $mount_point"
    
    # Unmount if already mounted
    if mount | grep -q "$mount_point"; then
        echo "Unmounting existing mount at $mount_point"
        umount "$mount_point" 2>/dev/null || diskutil unmount "$mount_point" 2>/dev/null
        sleep 1
    fi
    
    # Create mount point if it doesn't exist
    echo "Creating mount point directory..."
    # Create the mount point directory
    mkdir -p "$mount_point" 2>/dev/null
    
    # Verify mount point exists
    if [ ! -d "$mount_point" ]; then
        echo "❌ Failed to create mount point directory at $mount_point"
        echo "Creating a temporary mount point in your home directory instead"
        mount_point="$HOME/Desktop/temp-mount-$clean_share"
        mkdir -p "$mount_point"
        if [ ! -d "$mount_point" ]; then
            echo "❌ Failed to create temporary mount point. Aborting."
            return 1
        fi
        echo "Using temporary mount point: $mount_point"
    fi
    
    # Attempt to mount the share
    echo "\nMounting //$selected_host/$clean_share to $mount_point..."
    
    # Get local connection options
    local local_connection_options=""
    if [[ "$OSTYPE" == "darwin"* ]]; then
        local_connection_options=",nobrowse"
    elif [[ "$OSTYPE" == "linux-android"* ]] || command -v termux-setup-storage >/dev/null 2>&1; then
        local_connection_options=",rw,noperm"
    fi
    
    # Use the appropriate mounting method based on the OS type
    if [ "$os_type" == "MacOS" ] || [ -z "$os_type" ]; then
        # MacOS SMB servers typically work well with standard guest access
        if [ -n "$ROCKNIX_USER" ] && [ -n "$ROCKNIX_PASS" ]; then
            mount_cmd="mount -t smbfs //$ROCKNIX_USER:$ROCKNIX_PASS@$selected_host/$clean_share $mount_point$local_connection_options"
        else
            mount_cmd="mount -t smbfs //$selected_host/$clean_share $mount_point$local_connection_options"
        fi
    elif [ "$os_type" == "Linux" ] || [ "$os_type" == "Android" ]; then
        # Both Linux and Android use CIFS mounting
        if [ -n "$ROCKNIX_USER" ] && [ -n "$ROCKNIX_PASS" ]; then
            mount_cmd="mount -t cifs //$selected_host/$clean_share $mount_point -o username=$ROCKNIX_USER,password=$ROCKNIX_PASS$local_connection_options"
        else
            mount_cmd="mount -t cifs //$selected_host/$clean_share $mount_point -o guest$local_connection_options"
        fi
    fi
    
    # Execute the mount command
    echo "Executing mount command: $mount_cmd"
    eval "$mount_cmd"
    local mount_success=$?
    
    # Verify the mount was successful
    echo "\nVerifying mount status..."
    
    # Use the mount command's return code as the primary indicator of success
    if [ $mount_success -eq 0 ]; then
        # Try to find the mount in the system mount list for additional verification
        mount_check=$(mount | grep -i "$selected_host/$clean_share")
        point_check=$(mount | grep -i "$mount_point")
        
        # Display mount information if available
        if [ -n "$mount_check" ] || [ -n "$point_check" ]; then
            mount | grep -i "$selected_host/$clean_share" || mount | grep -i "$mount_point"
        else
            echo "Note: Mount command reported success but mount not visible in system mount list."
            echo "This can happen with some SMB configurations but the share should still be accessible."
        fi
        
        echo "\n✅ Mount successful! SMB share mounted at $mount_point"
        
        # Check if we can access the share
        echo "Testing share access..."
        # Try to list the directory and capture any errors
        ls_output=$(ls -la "$mount_point" 2>&1)
        ls_result=$?
        
        if [ $ls_result -eq 0 ] && [ -n "$ls_output" ]; then
            echo "✅ Share contents are accessible"
            
            # List the top-level directories in the share
            echo "\nContents of the SMB share:"
            ls -la "$mount_point" | head -10
            
            # Automatically set this as the ROMs directory
            ROMS_BASE_DIR="$mount_point"
            echo "\nROMs base directory set to: $ROMS_BASE_DIR"
            
            # No symbolic links needed - we're mounting directly like Finder does
            echo "\nShare mounted successfully at: $mount_point"
            
            # Set the ROM base directory based on the share type
            if [ "$is_rom_share" = true ]; then
                # For ROM shares, set the base directory to the mount point
                ROMS_BASE_DIR="$mount_point"
                echo "ROMs base directory set to: $ROMS_BASE_DIR"
            fi

            
            # No symbolic links are used - direct mounting only
            
            # Update all platform directories to use the new base
            NES_DIR="$ROMS_ROOT/nes"
            SNES_DIR="$ROMS_ROOT/snes"
            GENESIS_DIR="$ROMS_ROOT/genesis"
            GB_DIR="$ROMS_ROOT/gb"
            GBA_DIR="$ROMS_ROOT/gba"
            GBC_DIR="$ROMS_ROOT/gbc"
            GAMEGEAR_DIR="$ROMS_ROOT/gamegear"
            NGP_DIR="$ROMS_ROOT/ngp"
            SMS_DIR="$ROMS_ROOT/mastersystem"
            SEGACD_DIR="$ROMS_ROOT/segacd"
            SEGA32X_DIR="$ROMS_ROOT/sega32x"
            SATURN_DIR="$ROMS_ROOT/saturn"
            TG16_DIR="$ROMS_ROOT/tg16"
            TGCD_DIR="$ROMS_ROOT/tgcd"
            PS1_DIR="$ROMS_ROOT/psx"
            PS2_DIR="$ROMS_ROOT/ps2"
            N64_DIR="$ROMS_ROOT/n64"
            lynx_DIR="$ROMS_ROOT/lynx"
            LYNX_DIR="$ROMS_ROOT/lynx"
            
            # Check if the mounted directory has ROM subdirectories
            echo "\nChecking for existing ROM directories..."
            found_rom_dirs=false
            
            # List of common ROM directory names to check
            common_rom_dirs=("nes" "snes" "genesis" "gb" "gba" "gbc" "n64" "ps1" "lynx")
            
            for rom_dir in "${common_rom_dirs[@]}"; do
                if [ -d "$mount_point/$rom_dir" ]; then
                    echo "Found ROM directory: $rom_dir"
                    found_rom_dirs=true
                fi
            done
            
            if [ "$found_rom_dirs" = true ]; then
                echo "\nROM directories found in the mounted share!"
                # Open the file browser to the ROMs directory
                echo "\nOpening $ROMS_BASE_DIR in Finder..."
                open "$ROMS_BASE_DIR"
            else
                echo "\n⚠️ No standard ROM directories found in the mounted share."
                echo "This might not be the correct share for your ROMs."
                echo "You may want to try mounting a different share."
            fi
            
            # Only check for ROM directories without creating them
            echo "\nChecking for ROM directories (not creating any)..."
            for dir in "$NES_DIR" "$SNES_DIR" "$GENESIS_DIR" "$GB_DIR" "$GBA_DIR" "$GBC_DIR" "$GAMEGEAR_DIR" "$NGP_DIR" \
                      "$SMS_DIR" "$SEGACD_DIR" "$SEGA32X_DIR" "$SATURN_DIR" "$TG16_DIR" "$TGCD_DIR" "$PS1_DIR" \
                      "$PS2_DIR" "$N64_DIR" "$lynx_DIR" "$LYNX_DIR"; do
                if [ -d "$dir" ]; then
                    echo "Found ROM directory: $(basename "$dir")"
                fi
            done
        else
            echo "⚠️ Warning: Share is mounted but contents cannot be accessed."
            
            # Check mount point permissions
            mount_owner=$(ls -ld "$mount_point" | awk '{print $3}')
            current_user=$(whoami)
            
            if [ "$mount_owner" != "$current_user" ]; then
                echo "❌ Permission issue detected: Mount point is owned by $mount_owner, but you are $current_user"
                echo "This is likely a permission issue with the mounted share."
            else
                echo "Mount point ownership looks correct (owned by $current_user)"
            fi
            
            echo "\nPossible solutions:"
            echo "1. Try mounting with credentials (username/password)"
            echo "2. Check the permissions on the SMB server"
            echo "3. Try a different share"
            
            # Try to get more information about the failure
            echo "\nDetailed information about the share:"
            ls -la "$mount_point" 2>&1
            echo "\nPermissions of mount point:"
            ls -ld "$mount_point" 2>&1
        fi
    else
        # If mount_success is 0 but we couldn't access the share, it's a different kind of failure
        if [ $mount_success -eq 0 ]; then
            echo "\n⚠️ Warning: Mount command reported success, but the share contents cannot be accessed."
            echo "This is likely a permission or configuration issue with the share."
            
            # Check mount point permissions
            mount_owner=$(ls -ld "$mount_point" 2>/dev/null | awk '{print $3}')
            current_user=$(whoami)
            
            if [ -n "$mount_owner" ] && [ "$mount_owner" != "$current_user" ]; then
                echo "❌ Permission issue detected: Mount point is owned by $mount_owner, but you are $current_user"
            fi
            
            echo "\nTry the following solutions:"
            echo "1. Mount with credentials (username/password)"
            echo "2. Check permissions on the SMB server"
            echo "3. Try a different share"
        else
            echo "\n❌ Mount failed. The share could not be mounted."
            
            # Check if the server is reachable
            if ping -c 1 -W 1 "$selected_host" &> /dev/null; then
                echo "✅ Server $selected_host is reachable via ping"
                
                # Check if SMB ports are open
                if nc -z -G 1 "$selected_host" 445 &>/dev/null || nc -z -G 1 "$selected_host" 139 &>/dev/null; then
                    echo "✅ SMB service is running on $selected_host"
                    echo "\n⚠️ The server is reachable and SMB service is running, but mount failed."
                    echo "This is likely due to one of the following:"
                    echo "1. The share name '$clean_share' might not exist or is misspelled"
                    echo "2. You need credentials to access this share"
                    echo "3. There might be SMB protocol version incompatibility"
                else
                    echo "❌ No SMB service detected on $selected_host"
                    echo "\nThe server is reachable but SMB ports (445, 139) are not open."
                    echo "Please check if the SMB service is running on the server."
                fi
            else
                echo "❌ Server $selected_host is not reachable via ping"
                echo "\nPlease check your network connection and verify the server address."
            fi
        fi
        
        echo "\n=== Detailed Debugamegearing Information ==="
        echo "1. Mount point: $mount_point"
        ls -ld "$mount_point" 2>&1
        
        echo "\n2. Current SMB mounts:"
        mount | grep -i smbfs || echo "No SMB mounts found"
        
        echo "\n3. Network connectivity:"
        ping -c 1 -W 1 "$selected_host" 2>&1
        
        echo "\n4. SMB ports check:"
        nc -z -v -G 1 "$selected_host" 445 2>&1 || echo "Port 445 not accessible"
        nc -z -v -G 1 "$selected_host" 139 2>&1 || echo "Port 139 not accessible"
        
        echo "\n=== Recommended Actions ==="
        echo "1. Try using Finder to connect to the share (Go > Connect to Server)"
        echo "   Enter: smb://$selected_host/$clean_share"
        echo "2. If Finder asks for credentials, note them for use in this script"
        echo "3. Try selecting a different share name"
        echo "4. Verify the SMB server configuration"
    fi

    # Clean up temporary files
    rm -f "$smb_list_file" "$shares_list_file"
    
    read -p "Press Enter to continue..."
    return 0
}

# Function to scan for SMB hosts
scan_for_smb_hosts() {
    echo "Scanning for SMB hosts on the network... (Press any key to skip)"
    
    # Initialize detected hosts array (empty at start)
    DETECTED_SMB_HOSTS=()
    
    # Get the local IP and subnet - with Android compatibility
    local ip_addr=""
    local subnet=""
    
    # Detect if we're on Android
    local is_android=0
    if [ -f /system/build.prop ] || [ -d /system/app ] || [ -d /system/priv-app ]; then
        is_android=1
        # On Android, use ip command instead of ifconfig
        # First try to get the wlan0 IP directly with a simpler command
        ip_addr=$(ip -4 addr show wlan0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
        
        # If that fails, try alternative methods
        if [ -z "$ip_addr" ]; then
            # Try getprop
            ip_addr=$(getprop dhcp.wlan0.ipaddress)
        fi
        
        # If still empty, try the more complex parsing
        if [ -z "$ip_addr" ]; then
            local ip_info=$(ip addr show 2>/dev/null | grep "inet " | grep -v "127.0.0.1")
            ip_addr=$(echo "$ip_info" | grep "wlan0" | head -1 | awk '{print $2}' | cut -d/ -f1)
            
            # If wlan0 not found, try the first non-loopback interface
            if [ -z "$ip_addr" ]; then
                ip_addr=$(echo "$ip_info" | head -1 | awk '{print $2}' | cut -d/ -f1)
            fi
        fi
    else
        # On desktop systems, use ifconfig or ip command
        if command -v ifconfig >/dev/null 2>&1; then
            local ip_info=$(ifconfig | grep "inet " | grep -v 127.0.0.1)
            ip_addr=$(echo "$ip_info" | head -1 | awk '{print $2}')
        elif command -v ip >/dev/null 2>&1; then
            ip_addr=$(ip -4 addr show | grep -v "127.0.0.1" | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
        fi
    fi
    
    # Fallback to hardcoded subnet if we couldn't detect IP
    if [ -z "$ip_addr" ]; then
        echo "⚠️ Could not detect IP address, using default subnet 192.168.0"
        subnet="192.168.0"
    else
        subnet=$(echo "$ip_addr" | cut -d. -f1-3)
    fi
    
    echo "Your IP address: $ip_addr"
    echo "Scanning subnet: $subnet.x"
    
    # Set up to detect key press for skipping (fixed timeout)
    read -t 1 -n 1 key
    if [ $? -eq 0 ]; then
        echo "Scan skipped by user."
        return 0
    fi
    
    # Check if sshpass is available
    if command -v sshpass >/dev/null 2>&1; then
        echo "Using sshpass for authentication..."
    else
        echo "⚠️ sshpass not installed. Cannot attempt SSH connection."
    fi
    
    # Perform faster network scanning as a fallback
    echo "Scanning network for SMB hosts (quick scan)..."
    
    # Define specific IP ranges to scan - focus on common device IPs
    # This makes scanning much faster while still finding most devices
    scan_ranges=(
        # Router and common static IPs
        "1 10"
        # Common RockNix and device IPs based on user's setup
        "130 140"
        # Additional targeted range
        "150 160"
    )
    
    # Track progress
    total_to_scan=0
    for range in "${scan_ranges[@]}"; do
        start_ip=$(echo $range | cut -d' ' -f1)
        end_ip=$(echo $range | cut -d' ' -f2)
        total_to_scan=$((total_to_scan + end_ip - start_ip + 1))
    done
    
    echo "Scanning $total_to_scan IPs in targeted ranges..."
    
    # Create a temporary file to collect hosts from parallel processes
    local temp_hosts_file=$(mktemp)
    
    # Desktop version with background processes
    pids=()
    
    # Scan each range in parallel
    for range in "${scan_ranges[@]}"; do
        start_ip=$(echo $range | cut -d' ' -f1)
        end_ip=$(echo $range | cut -d' ' -f2)
        
        # Scan this range in background
        (
            for i in $(seq $start_ip $end_ip); do
                target="$subnet.$i"
                
                # Skip if it's our own IP
                if [ "$target" = "$ip_addr" ]; then
                    continue
                fi
                
                # Quick ping check (faster than full port scan)
                if ping -c 1 -W 1 "$target" &>/dev/null; then
                    # Check for SSH (port 22) first - RockNix uses SSH
                    if nc -z -w 1 "$target" 22 &>/dev/null; then
                        echo "Found SSH host: $target"
                        
                        # Always add the host to our list, even before verification
                        echo "$target" >> "$temp_hosts_file"
                        
                        # Try to verify if it's a RockNix device via SSH
                        if command -v sshpass >/dev/null 2>&1; then
                            # Try primary password
                            if sshpass -p "$ROCKNIX_PASS" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=2 -o BatchMode=yes "$ROCKNIX_USER@$target" "ls -la $ROCKNIX_ROMS_PATH" &>/dev/null; then
                                echo "✅ Verified RockNix device at $target (password: $ROCKNIX_PASS)"
                            # Try alternative password
                            elif sshpass -p "$ROCKNIX_PASS_ALT" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=2 -o BatchMode=yes "$ROCKNIX_USER@$target" "ls -la $ROCKNIX_ROMS_PATH" &>/dev/null; then
                                echo "✅ Verified RockNix device at $target (password: $ROCKNIX_PASS_ALT)"
                                # Swap passwords since the alternative worked
                                local temp="$ROCKNIX_PASS"
                                ROCKNIX_PASS="$ROCKNIX_PASS_ALT"
                                ROCKNIX_PASS_ALT="$temp"
                            else
                                # Still keep the host even if verification failed
                                echo "Found SSH host at $target (unverified)"
                            fi
                        else
                            # Add as potential host if sshpass isn't available
                            echo "No sshpass available to verify $target"
                        fi
                    # Then check for SMB (ports 445 and 139)
                    elif nc -z -w 1 "$target" 445 &>/dev/null; then
                        echo "Found SMB host: $target"
                        echo "$target" >> "$temp_hosts_file"
                    elif nc -z -w 1 "$target" 139 &>/dev/null; then
                        echo "Found SMB host (port 139): $target"
                        echo "$target" >> "$temp_hosts_file"
                    fi
                fi
            done
        ) &
        
        # Store background process ID
        pids+=($!)
    done
    
    # Wait for all background scans to complete
    for pid in "${pids[@]}"; do
        wait $pid
    done
    
    # Read hosts from temporary file into array
    if [ -f "$temp_hosts_file" ]; then
        while IFS= read -r host; do
            # Only add unique hosts to avoid duplicates
            if [[ ! " ${DETECTED_SMB_HOSTS[*]} " =~ " ${host} " ]]; then
                DETECTED_SMB_HOSTS+=("$host")
            fi
        done < "$temp_hosts_file"
        rm "$temp_hosts_file"
    fi
    
    # Display results
    if [ ${#DETECTED_SMB_HOSTS[@]} -gt 0 ]; then
        echo "✅ Found ${#DETECTED_SMB_HOSTS[@]} SMB/SSH hosts:"
        for i in "${!DETECTED_SMB_HOSTS[@]}"; do
            echo "   $((i+1)). ${DETECTED_SMB_HOSTS[$i]}"
        done
        
        # Set the first detected host as the current host if not already set
        if [ -z "$ROCKNIX_HOST" ]; then
            ROCKNIX_HOST="${DETECTED_SMB_HOSTS[0]}"
            echo "✅ Set current RockNix host to: $ROCKNIX_HOST"
        fi
    else
        echo "❌ No SMB/SSH hosts found on the network."
    fi
    
    echo "Press Enter to continue..."
    read -r
    
    return 0
}

# Function to handle ROM transfers to RockNix hosts
handle_rom_transfer() {
    local rom_path="$1"
    local platform="$2"
    
    # If no hosts have been detected yet, run a scan first
    if [ ${#DETECTED_SMB_HOSTS[@]} -eq 0 ]; then
        echo "No RockNix hosts detected yet. Running a quick scan..."
        scan_for_smb_hosts
        
        if [ ${#DETECTED_SMB_HOSTS[@]} -eq 0 ]; then
            echo "❌ No SMB hosts found. Cannot proceed with transfer."
            read -p "Press Enter to continue..."
            return 1
        fi
    fi
    
    # Check if we have SMB hosts detected
    if [ ${#DETECTED_SMB_HOSTS[@]} -gt 0 ]; then
        # Use sequential transfers instead of parallel for reliability
        echo "🔄 Transferring ROM to detected RockNix hosts (${#DETECTED_SMB_HOSTS[@]} hosts)..."
        
        # Determine destination directory
        local dest_dir="$ROCKNIX_ROMS_PATH/$platform"
        
        # Transfer to each host sequentially
        for host in "${DETECTED_SMB_HOSTS[@]}"; do
            echo "===== Transferring to $host ====="
            
            # Remove the host from known_hosts if it exists to avoid key verification issues
            ssh-keygen -R "$host" 2>/dev/null || true
            
            # Create directory with improved SSH options
            echo "Creating directory on $host..."
            if ! sshpass -p "$ROCKNIX_PASS" ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/dev/null "$ROCKNIX_USER@$host" "mkdir -p $dest_dir" 2>/dev/null; then
                # Try alternative password if primary fails
                sshpass -p "$ROCKNIX_PASS_ALT" ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/dev/null "$ROCKNIX_USER@$host" "mkdir -p $dest_dir" 2>/dev/null
            fi
            
            # Transfer the file with improved SSH options
            echo "Transferring file to $host:$dest_dir..."
            if sshpass -p "$ROCKNIX_PASS" scp -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/dev/null "$rom_path" "$ROCKNIX_USER@$host:$dest_dir/"; then
                echo "✅ File transferred successfully to $host!"
            elif sshpass -p "$ROCKNIX_PASS_ALT" scp -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/dev/null "$rom_path" "$ROCKNIX_USER@$host:$dest_dir/"; then
                echo "✅ File transferred successfully to $host (using alternative password)!"
            elif sshpass -p "$LAKKA_PASS" scp -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/dev/null "$rom_path" "$LAKKA_USER@$host:$dest_dir/"; then
                echo "✅ File transferred successfully to $host (using Lakka credentials)!"
            else
                echo "❌ File transfer failed to $host after all attempts."
            fi
            
            # Add a small delay between transfers
            sleep 1
        done
        
        echo "All transfers completed."
    else
        echo "⚠️ No RockNix hosts detected. ROM was downloaded locally only."
        echo "Run 'Scan for SMB hosts' from the SMB menu to detect RockNix devices."
    fi
}

# Function to connect to SMB hosts
connect_to_smb_host() {
    local host="$1"
    
    echo "Connecting to SMB host: $host"
    
    if [ -n "$ROCKNIX_USER" ] && [ -n "$ROCKNIX_PASS" ]; then
        echo "Attempting connection with credentials..."
        sshpass -p "$ROCKNIX_PASS" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$ROCKNIX_USER@$host" "ls -la /mnt/mmc/ROMS" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo "✅ Successfully connected to $host"
            # Update the ROCKNIX_HOST variable to use this host for future operations
            ROCKNIX_HOST="$host"
            echo "Available ROMs on $host:"
            sshpass -p "$ROCKNIX_PASS" ssh -o StrictHostKeyChecking=no "$ROCKNIX_USER@$host" "ls -la /mnt/mmc/ROMS"
            
            # Ask if user wants to transfer files
            echo ""
            read -p "Do you want to transfer files to this host? (y/n): " transfer_choice
            if [[ "$transfer_choice" == "y" || "$transfer_choice" == "Y" ]]; then
                transfer_files_to_smb_host "$host"
            fi
        else
            echo "❌ Failed to connect to $host"
        fi
    else
        echo "❌ No credentials provided for SMB connection"
    fi
    
    read -p "Press Enter to continue..."
    return 0
}

# Function to connect to all detected SMB hosts
connect_to_all_smb_hosts() {
    echo "Connecting to all detected SMB hosts..."
    
    if [ ${#DETECTED_SMB_HOSTS[@]} -eq 0 ]; then
        echo "No SMB hosts detected."
        read -p "Press Enter to continue..."
        return 0
    fi
    
    for host in "${DETECTED_SMB_HOSTS[@]}"; do
        echo "-------------------------------------------"
        echo "Connecting to $host..."
        connect_to_smb_host "$host"
    done
    
    return 0
}

# Function to transfer files to a host
transfer_files_to_smb_host() {
    local host="$1"
    
    echo "Transfer files to $host"
    echo "Enter the full path to the file you want to transfer:"
    read -e file_path
    
    if [ ! -f "$file_path" ]; then
        echo "❌ File not found: $file_path"
        return 1
    fi
    
    # Get the destination directory
    echo "Enter the destination directory on the remote host (e.g., /mnt/mmc/ROMS/NES):"
    read -e dest_dir
    
    # Default to /mnt/mmc/ROMS if empty
    if [ -z "$dest_dir" ]; then
        dest_dir="$ROCKNIX_ROMS_PATH"
    fi
    
    # Create the directory if it doesn't exist - try both password combinations
    echo "Creating directory $dest_dir on host $host..."
    
    # Try with primary RockNix password (rocknix)
    if sshpass -p "$ROCKNIX_PASS" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$ROCKNIX_USER@$host" "mkdir -p $dest_dir" >/dev/null 2>&1; then
        echo "✅ Successfully created directory with primary password"
        
        # Transfer the file with primary password
        echo "Transferring file to $host:$dest_dir using primary password..."
        if sshpass -p "$ROCKNIX_PASS" scp -o StrictHostKeyChecking=no "$file_path" "$ROCKNIX_USER@$host:$dest_dir/"; then
            echo "✅ File transferred successfully!"
            read -p "Press Enter to continue..."
            return 0
        else
            echo "❌ File transfer failed with primary password, trying alternative..."
        fi
    fi
    
    # Try with alternative RockNix password (root)
    echo "Trying alternative password..."
    if sshpass -p "$ROCKNIX_PASS_ALT" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$ROCKNIX_USER@$host" "mkdir -p $dest_dir" >/dev/null 2>&1; then
        echo "✅ Successfully created directory with alternative password"
        
        # Transfer the file with alternative password
        echo "Transferring file to $host:$dest_dir using alternative password..."
        if sshpass -p "$ROCKNIX_PASS_ALT" scp -o StrictHostKeyChecking=no "$file_path" "$ROCKNIX_USER@$host:$dest_dir/"; then
            echo "✅ File transferred successfully!"
            read -p "Press Enter to continue..."
            return 0
        fi
    fi
    
    # Try with Lakka credentials as a last resort
    echo "Trying Lakka credentials..."
    if sshpass -p "$LAKKA_PASS" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$LAKKA_USER@$host" "mkdir -p $dest_dir" >/dev/null 2>&1; then
        echo "✅ Successfully created directory with Lakka credentials"
        
        # Transfer the file with Lakka credentials
        echo "Transferring file to $host:$dest_dir using Lakka credentials..."
        if sshpass -p "$LAKKA_PASS" scp -o StrictHostKeyChecking=no "$file_path" "$LAKKA_USER@$host:$dest_dir/"; then
            echo "✅ File transferred successfully!"
            read -p "Press Enter to continue..."
            return 0
        fi
    fi
    
    echo "❌ File transfer failed with all credential combinations."
    read -p "Press Enter to continue..."
    return 1
}

# Function to show SMB menu
show_smb_menu() {
    clear
    echo "===== SMB Connection Menu ====="
    echo "1. Scan for SMB hosts"
    echo "2. Connect to a specific SMB host"
    echo "3. Connect to all detected SMB hosts"
    echo "4. Transfer files to current SMB host"
    echo "5. Transfer file to multiple hosts simultaneously"
    echo "6. Return to main menu"
    echo "============================="
    
    read -p "Enter your choice [1-6]: " choice
    
    case $choice in
        1)
            clear
            echo "===== Scanning for SMB Hosts ====="
            scan_for_smb_hosts
            read -p "Press Enter to continue..."
            show_smb_menu
            ;;
        2)
            clear
            echo "===== Connect to SMB Host ====="
            
            # If we have detected hosts, show them
            if [ ${#DETECTED_SMB_HOSTS[@]} -gt 0 ]; then
                echo "Select a host to connect to:"
                for i in "${!DETECTED_SMB_HOSTS[@]}"; do
                    echo "$((i+1)). ${DETECTED_SMB_HOSTS[$i]}"
                done
                echo "$((${#DETECTED_SMB_HOSTS[@]}+1)). Enter a different host"
                
                read -p "Enter your choice: " host_choice
                
                if [ "$host_choice" -le ${#DETECTED_SMB_HOSTS[@]} ]; then
                    # Connect to selected host
                    connect_to_smb_host "${DETECTED_SMB_HOSTS[$((host_choice-1))]}"
                else
                    # Enter a different host
                    read -p "Enter the IP address of the SMB host: " custom_host
                    connect_to_smb_host "$custom_host"
                fi
            else
                # No detected hosts, ask for manual entry
                read -p "Enter the IP address of the SMB host: " custom_host
                connect_to_smb_host "$custom_host"
            fi
            
            show_smb_menu
            ;;
        3)
            clear
            echo "===== Connect to All SMB Hosts ====="
            connect_to_all_smb_hosts
            show_smb_menu
            ;;
        4)
            clear
            echo "===== Transfer Files to SMB Host ====="
            if [ -z "$ROCKNIX_HOST" ]; then
                echo "No SMB host set. Please connect to a host first."
                read -p "Press Enter to continue..."
            else
                transfer_files_to_smb_host "$ROCKNIX_HOST"
            fi
            show_smb_menu
            ;;
        5)
            clear
            echo "===== Transfer to Multiple Hosts ====="
            transfer_file_to_multiple_hosts
            show_smb_menu
            ;;
        6)
            # Return to main menu
            return
            ;;
        *)
            echo "Invalid choice. Please try again."
            sleep 1
            show_smb_menu
            ;;
    esac
}

# Function to manually enter a host IP address
enter_custom_host() {
    clear
    echo "===== Enter Custom Host IP ====="
    echo "Enter the IP address of the RockNix/Lakka host:"
    read -p "IP Address: " custom_host
    
    # Validate IP address format
    if [[ ! $custom_host =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "❌ Invalid IP address format. Please enter a valid IP (e.g., 192.168.0.159)"
        read -p "Press Enter to continue..."
        return 1
    fi
    
    echo "Attempting to connect to $custom_host..."
    
    # Try to ping the host first
    if ping -c 1 -W 2 "$custom_host" >/dev/null 2>&1; then
        echo "✅ Host $custom_host is reachable via ping"
        
        # Check if SSH port is open
        if nc -z -w 2 "$custom_host" 22 >/dev/null 2>&1; then
            echo "✅ SSH service detected on $custom_host"
            
            # Add to detected hosts if not already there
            if [[ ! " ${DETECTED_SMB_HOSTS[@]} " =~ " $custom_host " ]]; then
                DETECTED_SMB_HOSTS+=("$custom_host")
                echo "✅ Added $custom_host to detected hosts list"
            fi
            
            # Try to connect using RockNix credentials (primary password - rocknix)
            echo "Trying to connect with RockNix credentials (primary password)..."
            if sshpass -p "$ROCKNIX_PASS" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$ROCKNIX_USER@$custom_host" "echo Connected" >/dev/null 2>&1; then
                echo "✅ Successfully connected to $custom_host with RockNix credentials (primary password)."
                # Add to detected hosts
                DETECTED_SMB_HOSTS+=("$custom_host")
                echo "Added $custom_host to detected hosts."
                
                # Ask if user wants to transfer files
                echo ""
                read -p "Do you want to transfer files to this host? (y/n): " transfer_choice
                if [[ "$transfer_choice" == "y" || "$transfer_choice" == "Y" ]]; then
                    transfer_files_to_smb_host "$custom_host"
                fi
                
                read -p "Press Enter to continue..."
                return 0
            fi
            
            # Try to connect with RockNix credentials (alternative password - root)
            echo "Trying to connect with RockNix credentials (alternative password)..."
            if sshpass -p "$ROCKNIX_PASS_ALT" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$ROCKNIX_USER@$custom_host" "echo Connected" >/dev/null 2>&1; then
                echo "✅ Successfully connected to $custom_host with RockNix credentials (alternative password)."
                # Add to detected hosts
                DETECTED_SMB_HOSTS+=("$custom_host")
                echo "Added $custom_host to detected hosts."
                
                # Ask if user wants to transfer files
                echo ""
                read -p "Do you want to transfer files to this host? (y/n): " transfer_choice
                if [[ "$transfer_choice" == "y" || "$transfer_choice" == "Y" ]]; then
                    transfer_files_to_smb_host "$custom_host"
                fi
                
                read -p "Press Enter to continue..."
                return 0
            fi
            
            # Try to connect with Lakka credentials
            echo "Trying to connect with Lakka credentials..."
            if sshpass -p "$LAKKA_PASS" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$LAKKA_USER@$custom_host" "echo Connected" >/dev/null 2>&1; then
                echo "✅ Successfully connected to $custom_host with Lakka credentials."
                # Add to detected hosts
                DETECTED_SMB_HOSTS+=("$custom_host")
                echo "Added $custom_host to detected hosts."
                
                # Ask if user wants to transfer files
                echo ""
                read -p "Do you want to transfer files to this host? (y/n): " transfer_choice
                if [[ "$transfer_choice" == "y" || "$transfer_choice" == "Y" ]]; then
                    transfer_files_to_smb_host "$custom_host"
                fi
                
                read -p "Press Enter to continue..."
                return 0
            fi
            
            echo "❌ Failed to connect to $custom_host with any known credentials."
            read -p "Press Enter to continue..."
            return 1
        fi
        
        echo "❌ No SSH service detected on $custom_host."
    else
        echo "❌ Host $custom_host is not reachable"
    fi
    
    read -p "Press Enter to continue..."
    return 0
}

# Function to show menu
show_menu() {
    clear
    echo "========================================"
    echo "           zuz ROM Downloader           "
    echo "========================================"
    local menu_options=(
        "Search Across All Platforms"
        "Scan for SMB Hosts"
        "Enter a Different Host"
        "NES (Nintendo Entertainment System)"
        "SNES (Super Nintendo)"
        "GB (Game Boy)"
        "GBA (Game Boy Advance)"
        "GBC (Game Boy Color)"
        "SMS (Sega Master System)"
        "Genesis (Sega Genesis)"
        "SEGACD (Sega CD)"
        "SEGA32X (Sega 32X)"
        "SATURN (Sega Saturn)"
        "gamegear (Sega Game Gear)"
        "NGP (Neo Geo Pocket)"
        "TG16 (TurboGrafx-16)"
        "TGCD (TurboGrafx-CD)"
        "PS1 (PlayStation)"
        "PS2 (PlayStation 2)"
        "N64 (Nintendo 64)"
        "lynx (Sega lynx)"
        "More Options"
        "Exit"
    )
    
    # Display menu options with numbers
    for i in "${!menu_options[@]}"; do
        echo "$((i+1)). ${menu_options[$i]}"
    done
    
    echo "----------------------------------------"
    echo "Use ↑↓ arrows and Enter, or directly type a number (1-23)"
    echo "----------------------------------------"
    
    # Add the direct input prompt
    read -p "Enter your choice [1-23]: " choice
    
    # If choice is empty or not a number, use menu_select for arrow key navigation
    if [[ -z "$choice" || ! "$choice" =~ ^[0-9]+$ || "$choice" -lt 1 || "$choice" -gt 23 ]]; then
        menu_select "${menu_options[@]}"
        choice=$?
    fi
    
    # Convert choice 23 (Exit) to 0 for compatibility
    if [ "$choice" -eq 23 ]; then
        choice=0
    fi
}

# Main function
main_menu() {
    # Set default platform if not already set
    if [ -z "$CURRENT_PLATFORM" ]; then
        CURRENT_PLATFORM="genesis"
        echo "Default platform set to Genesis"
    fi
    
    while true; do
        show_menu
        
        # Handle search across all platforms (choice 1)
        if [ "$choice" -eq 1 ]; then
            clear
            echo "===== Search Across All Platforms ====="
            read -p "Enter search term: " search_term
            
            if [ -z "$search_term" ]; then
                echo "Search term cannot be empty."
                read -p "Press Enter to continue..."
                continue
            fi
            
            # Call the search_all_platforms function
            search_all_platforms "$search_term"
            continue
        fi
        
        # Handle SMB scan option (choice 2)
        if [ "$choice" -eq 2 ]; then
            clear
            echo "===== Scan for SMB Hosts ====="
            scan_for_smb_hosts
            read -p "Press Enter to continue..."
            continue
        fi
        
        # Handle enter custom host option (choice 3)
        if [ "$choice" -eq 3 ]; then
            enter_custom_host
            continue
        fi
        
        # Handle platform selection (choices 4-21)
        if [ "$choice" -ge 4 ] && [ "$choice" -le 21 ]; then
            # Adjust the platform index to account for the new search option
            local platform_index=$((choice - 3))
            
            case $platform_index in
                1)
                    CURRENT_PLATFORM="nes"
                    echo "Selected platform: NES"
                    ;;
                2)
                    CURRENT_PLATFORM="snes"
                    echo "Selected platform: SNES"
                    ;;
                3)
                    CURRENT_PLATFORM="gb"
                    echo "Selected platform: Game Boy"
                    ;;
                4)
                    CURRENT_PLATFORM="gba"
                    echo "Selected platform: Game Boy Advance"
                    ;;
                5)
                    CURRENT_PLATFORM="gbc"
                    echo "Selected platform: Game Boy Color"
                    ;;
                6)
                    CURRENT_PLATFORM="sms"
                    echo "Selected platform: Sega Master System"
                    ;;
                7)
                    CURRENT_PLATFORM="genesis"
                    echo "Selected platform: Genesis"
                    ;;
                8)
                    CURRENT_PLATFORM="segacd"
                    echo "Selected platform: Sega CD"
                    ;;
                9)
                    CURRENT_PLATFORM="sega32x"
                    echo "Selected platform: Sega 32X"
                    ;;
                10)
                    CURRENT_PLATFORM="saturn"
                    echo "Selected platform: Sega Saturn"
                    ;;
                11)
                    CURRENT_PLATFORM="gamegear"
                    echo "Selected platform: Sega Game Gear"
                    ;;
                12)
                    CURRENT_PLATFORM="ngp"
                    echo "Selected platform: Neo Geo Pocket"
                    ;;
                13)
                    CURRENT_PLATFORM="tg16"
                    echo "Selected platform: TurboGrafx-16"
                    ;;
                14)
                    CURRENT_PLATFORM="tgcd"
                    echo "Selected platform: TurboGrafx-CD"
                    ;;
                15)
                    CURRENT_PLATFORM="ps1"
                    echo "Selected platform: PlayStation"
                    ;;
                16)
                    CURRENT_PLATFORM="ps2"
                    echo "Selected platform: PlayStation 2"
                    ;;
                17)
                    CURRENT_PLATFORM="n64"
                    echo "Selected platform: Nintendo 64"
                    ;;
                18)
                    CURRENT_PLATFORM="lynx"
                    echo "Selected platform: Sega lynx"
                    ;;
                *)
                    echo "Invalid choice. Using default platform: Genesis"
                    CURRENT_PLATFORM="genesis"
                    ;;
            esac
            
            # After selecting a platform, prompt for search
            clear
            echo "===== Search ROMs for $(to_uppercase $CURRENT_PLATFORM) ====="
            read -p "Enter search term (press Enter to list all): " search_term
            clear
            search_roms "$search_term" "$CURRENT_PLATFORM"
            read -p "Press Enter to continue..."
            continue
        fi
        
        # Handle other options
        case $choice in
            22)
                show_more_menu
                ;;
            0)
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid choice. Please try again."
                sleep 1
                ;;
        esac
    done
}

# Function to show more menu
show_more_menu() {
    clear
    echo "===== More Options ====="
    echo "Select an option:"
    echo "-----------------------------------------------------"
    echo "You can use ↑↓ arrows and Enter, or directly type a number (1-6)"
    echo "-----------------------------------------------------"
    
    local more_options=(
        "Connect to SMB"
        "Download All ROMs"
        "Open ROMs Folder"
        "Verify ROM Directories"
        "Copy ROMs to External Drive"
        "Back to Main Menu"
    )
    
    menu_select "${more_options[@]}"
    local more_choice=$?
    
    case $more_choice in
        1)
            show_smb_menu
            ;;
        2)
            clear
            echo "===== Download All ROMs ====="
            echo "Continue?"
            echo "-----------------------------------------------------"
            echo "You can use ↑↓ arrows and Enter, or directly type a number (1-2)"
            echo "-----------------------------------------------------"
            local confirm_options=("Yes" "No")
            menu_select "${confirm_options[@]}"
            local confirm_choice=$?
            
            if [ "$confirm_choice" -eq 1 ]; then
                download_all_roms "$CURRENT_PLATFORM"
            fi
            ;;
        3)
            clear
            echo "===== Open ROMs Folder ====="
            open_roms_folder
            ;;
        4)
            clear
            echo "===== Verify ROM Directories ====="
            verify_rom_directories
            ;;
        5)
            clear
            echo "===== Copy ROMs to External Drive ====="
            copy_roms_to_external
            ;;
        6)
            return
            ;;
    esac
    
    read -p "Press Enter to continue..."
}

# Function to search across all platforms
search_all_platforms() {
    local search_term="$1"
    
    clear
    echo "===== Searching Across All Platforms ====="
    echo "Search term: $search_term"
    
    # Get all supported platforms
    local all_platforms=("nes" "snes" "n64" "gbc" "gba" "genesis" "dreamcast" "ps1" "arcade")
    
    # Store search results
    local all_results=()
    local platform_map=()
    local platform_urls=()
    
    # Search each platform
    for platform in "${all_platforms[@]}"; do
        local archive_url=$(get_archive_url "$platform")
        
        if [ -z "$archive_url" ] || [ "$archive_url" == "PUT_DIRECTORY_HERE" ]; then
            echo "Skipping $platform (no archive URL configured)"
            continue
        fi
        
        echo "Searching $(to_uppercase $platform) platform..."
        
        # Create a temporary file for storing ROM names
        local rom_list_file=$(mktemp)
        
        # Check file extensions based on platform
        if [ "$platform" = "gbc" ]; then
            curl -s "$archive_url/" | grep -o '<a href="[^"]*\.gbc">' | 
            sed 's/<a href="\([^"]*\)">/\1/' > "$rom_list_file"
        elif [ "$platform" = "ps1" ]; then
            curl -s "$archive_url/" | grep -o '<a href="[^"]*\.cue">' | 
            sed 's/<a href="\([^"]*\)">/\1/' > "$rom_list_file"
        else
            curl -s "$archive_url/" | grep -o '<a href="[^"]*\.zip">' | 
            sed 's/<a href="\([^"]*\)">/\1/' > "$rom_list_file"
        fi
        
        # Filter ROMs based on search term
        while IFS= read -r rom_name; do
            # Decode URL-encoded names
            rom_name=$(urldecode "$rom_name")
            
            if echo "$rom_name" | grep -qi "$search_term"; then
                # Store the result with platform prefix
                all_results+=("[$platform] $rom_name")
                # Map to store original rom name and platform
                platform_map+=("$platform")
                platform_urls+=("$archive_url")
            fi
        done < "$rom_list_file"
        
        # Remove temporary file
        rm -f "$rom_list_file"
    done
    
    # Display results with arrow key selection
    if [ ${#all_results[@]} -eq 0 ]; then
        echo "No ROMs found matching your search across any platform."
        read -p "Press Enter to continue..."
        return 0
    fi
    
    # Continue showing ROM selection until user chooses to exit
    local continue_selection=1
    while [ $continue_selection -eq 1 ]; do
        clear
        echo "Found ${#all_results[@]} ROMs matching '$search_term' across all platforms"
        echo "Use arrow keys or enter number to select a ROM or choose an option"
        echo "-----------------------------------------------------"
        
        # Add options for downloading all ROMs and returning to main menu
        local display_options=("Download ALL matching ROMs to their respective platform folders" "${all_results[@]}" "Return to Main Menu")
        
        # Display ROMs with arrow key selection and numbers
        menu_select "${display_options[@]}"
        local selected=$?
        
        # Check if user selected the last option (Return to Main Menu)
        if [ $selected -eq ${#display_options[@]} ]; then
            echo "Returning to main menu..."
            break
        # Check if user selected the first option (Download All ROMs)
        elif [ $selected -eq 1 ]; then
            echo "Downloading all matching ROMs to their respective platform folders..."
            
            # Download each ROM in the filtered list
            local total_roms=${#all_results[@]}
            local success_count=0
            local fail_count=0
            
            for ((i=0; i<$total_roms; i++)); do
                local result="${all_results[$i]}"
                local platform="${platform_map[$i]}"
                local archive_url="${platform_urls[$i]}"
                
                # Extract ROM name without platform prefix
                local rom_file=$(echo "$result" | sed "s/\[$platform\] //")
                local decoded_rom_name=$(urldecode "$rom_file")
                
                # Get the platform directory
                local platform_dir="$ROMS_ROOT/$platform"
                
                # Create the directory if it doesn't exist
                mkdir -p "$platform_dir"
                
                echo "[$((i+1))/$total_roms] Downloading: $decoded_rom_name to $platform folder"
                
                # URL encode the ROM file for downloading
                local encoded_rom_file=$(echo "$rom_file" | sed 's/ /%20/g')
                
                # Construct the full download URL
                local download_url="${archive_url}/${encoded_rom_file}"
                
                # Download the ROM file
                curl -s -L -o "$platform_dir/$decoded_rom_name" "$download_url"
                
                if [ $? -eq 0 ]; then
                    echo "✅ ROM downloaded successfully to $platform_dir/$decoded_rom_name"
                    ((success_count++))
                    
                    # Transfer to RockNix if hosts are detected
                    if [ ${#DETECTED_SMB_HOSTS[@]} -gt 0 ]; then
                        handle_rom_transfer "$platform_dir/$decoded_rom_name" "$platform"
                    fi
                else
                    echo "❌ Failed to download ROM."
                    ((fail_count++))
                fi
                
                # Brief pause between downloads
                sleep 0.5
            done
            
            echo "Download summary: $success_count successful, $fail_count failed out of $total_roms ROMs"
            read -p "Press Enter to continue..."
            
            # Return to main menu after batch download
            break
        # Check if user pressed ESC (selected will be 0)
        elif [ $selected -eq 0 ]; then
            echo "Returning to main menu..."
            break
        # User selected a specific ROM
        else
            # Adjust the index to account for the "Download All" option
            local rom_index=$((selected-2))
            local selected_result="${all_results[$rom_index]}"
            local platform="${platform_map[$rom_index]}"
            local archive_url="${platform_urls[$rom_index]}"
            
            # Extract ROM name without platform prefix
            local selected_rom=$(echo "$selected_result" | sed "s/\[$platform\] //")
            
            # Show download options for this ROM
            clear
            echo "Selected ROM: $selected_rom (Platform: $(to_uppercase $platform))"
            echo "Choose an action:"
            echo "-----------------------------------------------------"
            
            local rom_options=("Download ROM to $platform folder" "Download ROM and transfer to RockNix" "Return to ROM list")
            
            menu_select "${rom_options[@]}"
            local rom_action=$?
            
            case $rom_action in
                1) # Download ROM locally only
                    # Get the platform directory
                    local platform_dir="$ROMS_ROOT/$platform"
                    mkdir -p "$platform_dir"
                    
                    local decoded_rom_name=$(urldecode "$selected_rom")
                    local encoded_rom_file=$(echo "$selected_rom" | sed 's/ /%20/g')
                    local download_url="${archive_url}/${encoded_rom_file}"
                    
                    echo "Downloading ROM: $decoded_rom_name to $platform folder"
                    curl -s -L -o "$platform_dir/$decoded_rom_name" "$download_url"
                    
                    if [ $? -eq 0 ]; then
                        echo "✅ ROM downloaded successfully to $platform_dir/$decoded_rom_name"
                    else
                        echo "❌ Failed to download ROM."
                    fi
                    read -p "Press Enter to continue..."
                    ;;
                2) # Download ROM and transfer to RockNix
                    # First download locally
                    local platform_dir="$ROMS_ROOT/$platform"
                    mkdir -p "$platform_dir"
                    
                    local decoded_rom_name=$(urldecode "$selected_rom")
                    local encoded_rom_file=$(echo "$selected_rom" | sed 's/ /%20/g')
                    local download_url="${archive_url}/${encoded_rom_file}"
                    
                    echo "Downloading ROM: $decoded_rom_name to $platform folder"
                    curl -s -L -o "$platform_dir/$decoded_rom_name" "$download_url"
                    
                    if [ $? -eq 0 ]; then
                        echo "✅ ROM downloaded successfully to $platform_dir/$decoded_rom_name"
                        # Then transfer to RockNix
                        handle_rom_transfer "$platform_dir/$decoded_rom_name" "$platform"
                    else
                        echo "❌ Failed to download ROM."
                    fi
                    read -p "Press Enter to continue..."
                    ;;
                3) # Return to ROM list
                    # Do nothing, just continue the loop
                    ;;
            esac
        fi
    done
    
    echo "Returning to main menu..."
}

# Function to search and list ROMs
search_roms() {
    local search_term="$1"
    local platform="$2"
    
    # If platform is not provided, use the current platform
    if [ -z "$platform" ]; then
        platform="$CURRENT_PLATFORM"
    fi
    
    # Get the archive URL from the function
    local archive_url=$(get_archive_url "$platform")
    
    if [ -z "$archive_url" ]; then
        echo "Error: No archive URL found for platform $(to_uppercase $platform)"
        read -p "Press Enter to continue..."
        return 1
    fi
    
    echo "Searching for ROMs in $(to_uppercase $platform) platform..."
    echo "Archive URL: $archive_url"
    
    # Get the list of ROMs from the archive
    echo "Fetching ROM list..."
    
    # Create a temporary file for storing ROM names
    local rom_list_file=$(mktemp)
    
    # Check if we're dealing with GBC platform which has .gbc files instead of .zip files
    if [ "$platform" = "gbc" ]; then
        curl -s "$archive_url/" | grep -o '<a href="[^"]*\.gbc">' | 
        sed 's/<a href="\([^"]*\)">/\1/' > "$rom_list_file"
    elif [ "$platform" = "ps1" ]; then
        # PS1 platform uses .bin and .cue files
        curl -s "$archive_url/" | grep -o '<a href="[^"]*\.cue">' | 
        sed 's/<a href="\([^"]*\)">/\1/' > "$rom_list_file"
    else
        # Get all zip files from the archive
        curl -s "$archive_url/" | grep -o '<a href="[^"]*\.zip">' | 
        sed 's/<a href="\([^"]*\)">/\1/' > "$rom_list_file"
    fi
    
    # Filter ROMs based on search term if provided
    local filtered_roms=()
    local rom_name
    
    while IFS= read -r rom_name; do
        # Decode URL-encoded names
        rom_name=$(urldecode "$rom_name")
        
        # If search term is provided, filter the results
        if [ -n "$search_term" ]; then
            if echo "$rom_name" | grep -qi "$search_term"; then
                filtered_roms+=("$rom_name")
            fi
        else
            filtered_roms+=("$rom_name")
        fi
    done < "$rom_list_file"
    
    # Remove temporary file
    rm -f "$rom_list_file"
    
    # Display results with arrow key selection
    if [ ${#filtered_roms[@]} -eq 0 ]; then
        echo "No ROMs found matching your search."
        read -p "Press Enter to continue..."
        return 0
    fi
    
    # Continue showing ROM selection until user chooses to exit
    local continue_selection=1
    while [ $continue_selection -eq 1 ]; do
        clear
        echo "Found ${#filtered_roms[@]} ROMs matching your search"
        echo "Use arrow keys or enter number to select a ROM to download or choose an option"
        echo "-----------------------------------------------------"
        
        # Add options for downloading all ROMs and returning to main menu
        local display_options=("Download All ROMs to $platform folder" "${filtered_roms[@]}" "Return to Main Menu")
        
        # Display ROMs with arrow key selection and numbers
        menu_select "${display_options[@]}"
        local selected=$?
        
        # Check if user selected the last option (Return to Main Menu)
        if [ $selected -eq ${#display_options[@]} ]; then
            echo "Returning to main menu..."
            break
        # Check if user selected the first option (Download All ROMs)
        elif [ $selected -eq 1 ]; then
            echo "Downloading all ROMs to $platform folder..."
            
            # Get the platform directory
            local platform_dir="$ROMS_ROOT/$platform"
            
            # Create the directory if it doesn't exist
            mkdir -p "$platform_dir"
            
            # Download each ROM in the filtered list
            local total_roms=${#filtered_roms[@]}
            local success_count=0
            local fail_count=0
            
            for ((i=0; i<$total_roms; i++)); do
                local rom_file="${filtered_roms[$i]}"
                local decoded_rom_name=$(urldecode "$rom_file")
                
                echo "[$((i+1))/$total_roms] Downloading: $decoded_rom_name"
                
                # URL encode the ROM file for downloading
                local encoded_rom_file=$(echo "$rom_file" | sed 's/ /%20/g')
                
                # Construct the full download URL
                local download_url="${archive_url}/${encoded_rom_file}"
                
                # Download the ROM file
                curl -s -L -o "$platform_dir/$decoded_rom_name" "$download_url"
                
                if [ $? -eq 0 ]; then
                    echo "✅ ROM downloaded successfully to $platform_dir/$decoded_rom_name"
                    ((success_count++))
                    
                    # Transfer to RockNix if hosts are detected
                    if [ ${#DETECTED_SMB_HOSTS[@]} -gt 0 ]; then
                        handle_rom_transfer "$platform_dir/$decoded_rom_name" "$platform"
                    fi
                else
                    echo "❌ Failed to download ROM."
                    ((fail_count++))
                fi
                
                # Brief pause between downloads
                sleep 0.5
            done
            
            echo "Download summary: $success_count successful, $fail_count failed out of $total_roms ROMs"
            read -p "Press Enter to continue..."
            
            # Return to main menu after batch download
            break
        # Check if user pressed ESC (selected will be 0)
        elif [ $selected -eq 0 ]; then
            echo "Returning to main menu..."
            break
        # User selected a specific ROM (offset by 1 due to the "Download All" option)
        else
            # Adjust the index to account for the "Download All" option
            local rom_index=$((selected-2))
            local selected_rom="${filtered_roms[$rom_index]}"
            
            # Show download options for this ROM
            clear
            echo "Selected ROM: $selected_rom"
            echo "Choose an action:"
            echo "-----------------------------------------------------"
            
            local rom_options=("Download ROM to $platform folder" "Download ROM and transfer to RockNix" "Return to ROM list")
            
            menu_select "${rom_options[@]}"
            local rom_action=$?
            
            case $rom_action in
                1) # Download ROM locally only
                    download_rom "$selected_rom" "$platform"
                    ;;
                2) # Download ROM and transfer to RockNix
                    # First download locally
                    local platform_dir="$ROMS_ROOT/$platform"
                    mkdir -p "$platform_dir"
                    
                    local decoded_rom_name=$(urldecode "$selected_rom")
                    local encoded_rom_file=$(echo "$selected_rom" | sed 's/ /%20/g')
                    local download_url="${archive_url}/${encoded_rom_file}"
                    
                    echo "Downloading ROM: $decoded_rom_name"
                    curl -s -L -o "$platform_dir/$decoded_rom_name" "$download_url"
                    
                    if [ $? -eq 0 ]; then
                        echo "✅ ROM downloaded successfully to $platform_dir/$decoded_rom_name"
                        # Then transfer to RockNix
                        handle_rom_transfer "$platform_dir/$decoded_rom_name" "$platform"
                    else
                        echo "❌ Failed to download ROM."
                    fi
                    ;;
                3) # Return to ROM list
                    # Do nothing, just continue the loop
                    ;;
            esac
            
            # Brief pause to let user see the download completed
            sleep 1
        fi
    done
    
    echo "Returning to main menu..."
}

# Function to download a ROM
download_rom() {
    local rom_file="$1"
    local platform="$2"
    
    # If no arguments were provided, this is a direct call from the menu
    if [ -z "$rom_file" ]; then
        clear
        echo "===== Download ROM ====="
        
        # Check if a platform is selected
        if [ -z "$CURRENT_PLATFORM" ]; then
            echo "Please select a platform first."
            select_platform
        fi
        
        # Get the platform directory
        local platform_dir=$(get_platform_dir "$CURRENT_PLATFORM")
        
        # Create the directory if it doesn't exist
        mkdir -p "$platform_dir"
        
        # Get the archive URL for the platform
        local archive_url=$(get_archive_url "$CURRENT_PLATFORM")
        
        if [ -z "$archive_url" ] || [ "$archive_url" == "PUT_DIRECTORY_HERE" ]; then
            echo "Archive URL not configured for platform: $CURRENT_PLATFORM"
            read -p "Press Enter to continue..."
            return 1
        fi
        
        # Prompt for search term
        read -p "Enter search term for $CURRENT_PLATFORM ROM: " search_term
        
        if [ -z "$search_term" ]; then
            echo "Search term cannot be empty."
            read -p "Press Enter to continue..."
            return 1
        fi
        
        # Search for ROMs
        search_roms "$search_term" "$CURRENT_PLATFORM"
        
        # Prompt for ROM selection
        read -p "Enter the number of the ROM to download (0 to cancel): " rom_choice
        
        if [ "$rom_choice" -eq 0 ]; then
            echo "Download cancelled."
            read -p "Press Enter to continue..."
            return 0
        fi
        
        # Get the ROM URL from the search results
        local rom_url=$(sed -n "${rom_choice}p" "$TEMP_FILE")
        
        if [ -z "$rom_url" ]; then
            echo "Invalid selection."
            read -p "Press Enter to continue..."
            return 1
        fi
        
        # Extract the ROM filename from the URL
        local rom_filename=$(basename "$rom_url")
        rom_filename=$(urldecode "$rom_filename")
        
        # Download the ROM
        echo "Downloading $rom_filename..."
        curl -L -o "$platform_dir/$rom_filename" "$rom_url"
        
        if [ $? -eq 0 ]; then
            echo "✅ ROM downloaded successfully to $platform_dir/$rom_filename"
            handle_rom_transfer "$platform_dir/$rom_filename" "$CURRENT_PLATFORM"
        else
            echo "❌ Failed to download ROM."
        fi
    else
        # We already have a ROM file selected from the browse menu
        
        # If platform is not provided, use the current platform
        if [ -z "$platform" ]; then
            platform="$CURRENT_PLATFORM"
        fi
        
        # Get the platform directory
        local platform_dir=$(get_platform_dir "$platform")
        
        # Create the directory if it doesn't exist
        mkdir -p "$platform_dir"
        
        # Extract just the filename without extension for display
        local rom_name=$(basename "$rom_file")
        local decoded_rom_name=$(urldecode "$rom_name")
        
        # Get the archive URL from the function
        local archive_url=$(get_archive_url "$platform")
        
        if [ -z "$archive_url" ]; then
            echo "Error: No archive URL found for platform $(to_uppercase $platform)"
            return 1
        fi
        
        echo "Downloading ROM: $decoded_rom_name"
        
        # URL encode the ROM file for downloading
        local encoded_rom_file=$(echo "$rom_file" | sed 's/ /%20/g')
        
        # Construct the full download URL
        local download_url="${archive_url}/${encoded_rom_file}"
        
        # Download the ROM file
        curl -s -L -o "$platform_dir/$decoded_rom_name" "$download_url"
        
        if [ $? -eq 0 ]; then
            echo "✅ ROM downloaded successfully to $platform_dir/$decoded_rom_name"
            handle_rom_transfer "$platform_dir/$decoded_rom_name" "$platform"
        else
            echo "❌ Failed to download ROM."
        fi
    fi
    
    read -p "Press Enter to continue..."
    return 0
}

# Function to copy ROMs to external drive
copy_roms_to_external() {
    clear
    echo "===== Copy ROMs to External Drive ====="
    echo "Enter the path to your external drive (e.g., /Volumes/EXTERNAL):"
    read -r external_path
    
    # Validate external drive path
    if [ ! -d "$external_path" ]; then
        echo "Error: Directory $external_path does not exist."
        return 1
    fi
    
    if [ ! -w "$external_path" ]; then
        echo "Error: No write permission for $external_path"
        return 1
    fi
    
    # Create ROMs directory on external drive
    local external_roms_dir="$external_path/ROMs"
    mkdir -p "$external_roms_dir"
    
    # Copy current platform's ROMs if a platform is selected
    if [ -n "$CURRENT_PLATFORM" ]; then
        local platform_dir=$(get_platform_dir "$CURRENT_PLATFORM")
        local external_platform_dir="$external_roms_dir/$CURRENT_PLATFORM"
        
        if [ -d "$platform_dir" ]; then
            echo "Copying $CURRENT_PLATFORM ROMs..."
            mkdir -p "$external_platform_dir"
            
            # Use rsync if available for better performance and resume capability
            if command -v rsync >/dev/null 2>&1; then
                rsync -av --progress "$platform_dir/" "$external_platform_dir/"
            else
                # Fallback to cp if rsync is not available
                cp -Rv "$platform_dir/"* "$external_platform_dir/" 2>/dev/null || true
            fi
            
            echo "Finished copying $CURRENT_PLATFORM ROMs to $external_platform_dir"
        else
            echo "No ROMs found for platform $CURRENT_PLATFORM"
        fi
    else
        echo "No platform selected. Copying all ROMs..."
        # Copy all platform directories
        for platform_dir in "$ROMS_ROOT"/*; do
            if [ -d "$platform_dir" ]; then
                local platform_name=$(basename "$platform_dir")
                local external_platform_dir="$external_roms_dir/$platform_name"
                
                echo "Copying $platform_name ROMs..."
                mkdir -p "$external_platform_dir"
                
                if command -v rsync >/dev/null 2>&1; then
                    rsync -av --progress "$platform_dir/" "$external_platform_dir/"
                else
                    cp -Rv "$platform_dir/"* "$external_platform_dir/" 2>/dev/null || true
                fi
            fi
        done
        echo "Finished copying all ROMs"
    fi
}

# Function to transfer a file to multiple hosts simultaneously
transfer_file_to_multiple_hosts() {
    echo "Transfer a file to multiple hosts simultaneously"
    
    # Check if we have hosts detected
    if [ ${#DETECTED_SMB_HOSTS[@]} -eq 0 ]; then
        echo "No hosts detected. Running a quick scan..."
        scan_for_smb_hosts
        
        if [ ${#DETECTED_SMB_HOSTS[@]} -eq 0 ]; then
            echo "❌ No hosts found. Cannot proceed with transfer."
            read -p "Press Enter to continue..."
            return 1
        fi
    fi
    
    # Get the file to transfer
    echo "Enter the full path to the file you want to transfer:"
    read -e file_path
    
    if [ ! -f "$file_path" ]; then
        echo "❌ File not found: $file_path"
        read -p "Press Enter to continue..."
        return 1
    fi
    
    # Get the destination directory
    echo "Enter the destination directory on the remote hosts (e.g., /mnt/mmc/ROMS/NES):"
    read -e dest_dir
    
    # Default to /mnt/mmc/ROMS if empty
    if [ -z "$dest_dir" ]; then
        dest_dir="$ROCKNIX_ROMS_PATH"
    fi
    
    # Display the list of detected hosts
    echo "Detected hosts:"
    for i in "${!DETECTED_SMB_HOSTS[@]}"; do
        echo "$((i+1)). ${DETECTED_SMB_HOSTS[$i]}"
    done
    
    # Ask which hosts to transfer to
    echo "Enter the numbers of the hosts to transfer to (comma-separated, e.g., '1 3'):"
    read host_selection
    
    # Process host selection
    selected_hosts=()
    
    if [[ "$host_selection" == "all" ]]; then
        selected_hosts=("${DETECTED_SMB_HOSTS[@]}")
    else
        IFS=',' read -ra host_indices <<< "$host_selection"
        for index in "${host_indices[@]}"; do
            # Convert to zero-based index
            idx=$((index-1))
            if [ "$idx" -ge 0 ] && [ "$idx" -lt "${#DETECTED_SMB_HOSTS[@]}" ]; then
                selected_hosts+=("${DETECTED_SMB_HOSTS[$idx]}")
            else
                echo "⚠️ Invalid host number: $index"
            fi
        done
    fi
    
    if [ ${#selected_hosts[@]} -eq 0 ]; then
        echo "❌ No valid hosts selected."
        read -p "Press Enter to continue..."
        return 1
    fi
    
    echo "Selected ${#selected_hosts[@]} hosts for transfer."
    
    # Confirm the transfer
    echo "You are about to transfer '$file_path' to '$dest_dir' on the following hosts:"
    for host in "${selected_hosts[@]}"; do
        echo "- $host"
    done
    
    read -p "Proceed with transfer? (y/n): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Transfer cancelled."
        read -p "Press Enter to continue..."
        return 0
    fi
    
    # Perform the transfers
    success_count=0
    fail_count=0
    
    for host in "${selected_hosts[@]}"; do
        echo "---------------------------------------------"
        echo "Transferring to $host..."
        
        # Create the directory - try all credential combinations
        echo "Creating directory $dest_dir on $host..."
        dir_created=false
        
        # Try with primary RockNix password (rocknix)
        if sshpass -p "$ROCKNIX_PASS" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$ROCKNIX_USER@$host" "mkdir -p $dest_dir" >/dev/null 2>&1; then
            echo "✅ Successfully created directory with primary password"
            dir_created=true
            
            # Transfer the file with primary password
            echo "Transferring file to $host:$dest_dir using primary password..."
            if sshpass -p "$ROCKNIX_PASS" scp -o StrictHostKeyChecking=no "$file_path" "$ROCKNIX_USER@$host:$dest_dir/"; then
                echo "✅ File transferred successfully to $host!"
                ((success_count++))
                continue
            else
                echo "❌ File transfer failed with primary password, trying alternative..."
            fi
        fi
        
        # If we're here, either directory creation or file transfer failed with primary password
        # Try with alternative RockNix password (root)
        if ! $dir_created; then
            echo "Trying alternative password for directory creation..."
            if sshpass -p "$ROCKNIX_PASS_ALT" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$ROCKNIX_USER@$host" "mkdir -p $dest_dir" >/dev/null 2>&1; then
                echo "✅ Successfully created directory with alternative password"
                dir_created=true
            fi
        fi
        
        # Try file transfer with alternative password
        echo "Transferring file to $host:$dest_dir using alternative password..."
        if sshpass -p "$ROCKNIX_PASS_ALT" scp -o StrictHostKeyChecking=no "$file_path" "$ROCKNIX_USER@$host:$dest_dir/"; then
            echo "✅ File transferred successfully to $host!"
            ((success_count++))
            continue
        fi
        
        # If we're still here, try Lakka credentials as a last resort
        if ! $dir_created; then
            echo "Trying Lakka credentials for directory creation..."
            if sshpass -p "$LAKKA_PASS" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$LAKKA_USER@$host" "mkdir -p $dest_dir" >/dev/null 2>&1; then
                echo "✅ Successfully created directory with Lakka credentials"
                dir_created=true
            fi
        fi
        
        # Try file transfer with Lakka credentials
        echo "Transferring file to $host:$dest_dir using Lakka credentials..."
        if sshpass -p "$LAKKA_PASS" scp -o StrictHostKeyChecking=no "$file_path" "$LAKKA_USER@$host:$dest_dir/"; then
            echo "✅ File transferred successfully to $host!"
            ((success_count++))
        else {
            echo "❌ File transfer failed to $host."
            ((fail_count++))
        }
        fi
    done
    
    echo "---------------------------------------------"
    echo "Transfer summary:"
    echo "✅ Successfully transferred to $success_count hosts"
    echo "❌ Failed to transfer to $fail_count hosts"
    
    read -p "Press Enter to continue..."
    return 0
}

# Clean up on exit
trap "rm -f $TEMP_FILE; tput cnorm" EXIT INT TERM

# Start the main menu
main_menu
