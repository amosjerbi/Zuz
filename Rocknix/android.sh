#!/bin/bash

# Set variables
CURRENT_PLATFORM=""
# ROMS_ROOT="games-internal/roms"  # RockNix local storage path
ROMS_ROOT="/storage/emulated/0/Download/roms"  # Android Download ROMs folder
ROCKNIX_USER="root"
ROCKNIX_PASS="rocknix"  # Correct RockNix password
ROCKNIX_ROMS_PATH="/storage/roms"  # RockNix storage path
DETECTED_SMB_HOSTS=()  # Array to store detected SMB hosts

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
TEMP_FILE="/storage/emulated/0/Download/temp_rom_list.txt"
SMB_MOUNT_DIR="storage/roms"

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
        "nes") echo "$base_url/PUT_DIRECTORY_HERE";;
        "snes") echo "$base_url/PUT_DIRECTORY_HERE";;
        "genesis") echo "$base_url/PUT_DIRECTORY_HERE";;
        "gb") echo "$base_url/PUT_DIRECTORY_HERE";;
        "gba") echo "$base_url/PUT_DIRECTORY_HERE";;
        "gbc") echo "$base_url/PUT_DIRECTORY_HERE";;
        "gg") echo "$base_url/PUT_DIRECTORY_HERE";;
        "ngp") echo "$base_url/PUT_DIRECTORY_HERE";;
        "sms") echo "$base_url/PUT_DIRECTORY_HERE";;
        "segacd") echo "$base_url/PUT_DIRECTORY_HERE";;
        "sega32x") echo "$base_url/PUT_DIRECTORY_HERE";;
        "saturn") echo "$base_url/PUT_DIRECTORY_HERE";;
        "tg16") echo "$base_url/PUT_DIRECTORY_HERE";;
        "tgcd") echo "$base_url/PUT_DIRECTORY_HERE";;
        "ps1") echo "$base_url/PUT_DIRECTORY_HERE";;
        "ps2") echo "$base_url/PUT_DIRECTORY_HERE";;
        "n64") echo "$base_url/PUT_DIRECTORY_HERE";;
        "lynx") echo "$base_url/PUT_DIRECTORY_HERE";;
        *) echo "";;
    esac
}

# Function to get platform directory
get_platform_dir() {
    local platform="$1"
    local base_dir="$HOME/Desktop/Aroms"  # Mac Desktop ROMs folder
    
    # Map platform name to directory name
    case "$platform" in
        "nes") echo "$base_dir/nes";;
        "snes") echo "$base_dir/snes";;
        "genesis") echo "$base_dir/genesis";;
        "gb") echo "$base_dir/gb";;
        "gba") echo "$base_dir/gba";;
        "gbc") echo "$base_dir/gbc";;
        "gg") echo "$base_dir/gamegear";;
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
        "gg") platform_subdir="gamegear" ;;
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
            '') 
        esac
    done
}

# Function to select a platform
select_platform() {
    clear
    echo "Select a platform (use ↑↓ arrows, press Enter to select):"
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
        "GG (Sega Game Gear)"
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
            CURRENT_PLATFORM="gg"
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
            
            # Add known SMB server (always include this)
            echo "$ROCKNIX_HOST" > "$smb_list_file"
            
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
            
            # Check for SMB on the known server directly
            echo "Checking if $ROCKNIX_HOST is running SMB..."
            if nc -z -G 1 "$ROCKNIX_HOST" 445 2>/dev/null || nc -z -G 1 "$ROCKNIX_HOST" 139 2>/dev/null; then
                echo "✅ SMB service detected on $ROCKNIX_HOST"
            else
                echo "⚠️ No SMB service detected on $ROCKNIX_HOST"
            fi
            
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
    echo "Select a share to connect to (use ↑↓ arrows, press Enter to select):"
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
                echo "✅ Server $selected_host is reachable"
                
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
                echo "❌ Server $selected_host is not reachable"
                echo "\nPlease check your network connection and verify the server address."
            fi
        fi
        
        echo "\n=== Detailed Debugging Information ==="
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
        # On desktop systems, use ifconfig
        local ip_info=$(ifconfig | grep "inet " | grep -v 127.0.0.1)
        ip_addr=$(echo "$ip_info" | awk '{print $2}')
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
    
    # Perform faster network scanning
    echo "Scanning network for SMB hosts (quick scan)..."
    
    # Define specific IP ranges to scan - focus on common device IPs
    # This makes scanning much faster while still finding most devices
    scan_ranges=(
        # Router and common static IPs
        "1 10"
        # Common RockNix and device IPs based on user's setup
        "130 160"
    )
    
    # Track progress
    total_to_scan=0
    for range in "${scan_ranges[@]}"; do
        start_ip=$(echo $range | cut -d' ' -f1)
        end_ip=$(echo $range | cut -d' ' -f2)
        total_to_scan=$((total_to_scan + end_ip - start_ip + 1))
    done
    
    echo "Scanning $total_to_scan IPs in targeted ranges..."
    
    # Android-optimized scanning
    if [ $is_android -eq 1 ]; then
        echo "Using Android-optimized scanning..."
        
        # Direct check for known RockNix host (from memory)
        echo "Checking known RockNix host: 192.168.0.132"
        if ping -c 1 -W 1 "192.168.0.132" >/dev/null 2>&1; then
            echo "✅ 192.168.0.132 is reachable"
            
            # Check if port 445 (SMB) is open - Android-compatible syntax
            if nc -z -w 1 "192.168.0.132" 445 >/dev/null 2>&1; then
                echo "✅ 192.168.0.132 has SMB service (port 445 open)"
                DETECTED_SMB_HOSTS+=("192.168.0.132")
            else
                echo "❌ 192.168.0.132 does not have SMB service"
            fi
        else
            echo "❌ 192.168.0.132 is not reachable"
        fi
        
        # Sequential scan for Android (no background processes)
        for range in "${scan_ranges[@]}"; do
            start_ip=$(echo $range | cut -d' ' -f1)
            end_ip=$(echo $range | cut -d' ' -f2)
            
            echo "Scanning range $subnet.$start_ip to $subnet.$end_ip"
            for i in $(seq $start_ip $end_ip); do
                target="$subnet.$i"
                
                # Skip if it's the already checked RockNix host
                if [ "$target" = "192.168.0.132" ]; then
                    continue
                fi
                
                # Quick ping check
                if ping -c 1 -W 1 "$target" >/dev/null 2>&1; then
                    echo -n "Testing $target... "
                    
                    # Check if port 445 (SMB) is open - Android-compatible syntax
                    if nc -z -w 1 "$target" 445 >/dev/null 2>&1; then
                        echo "SMB service found ✅"
                        DETECTED_SMB_HOSTS+=("$target")
                    else
                        echo "no SMB service ❌"
                    fi
                fi
            done
        done
    else
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
                    
                    # Quick ping check (faster than full port scan)
                    if ping -c 1 -W 1 "$target" &>/dev/null; then
                        # Check if port 445 (SMB) is open
                        if nc -z -w 1 "$target" 445 &>/dev/null; then
                            # Found an SMB host
                            DETECTED_SMB_HOSTS+=("$target")
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
    fi
    
    # Display results
    if [ ${#DETECTED_SMB_HOSTS[@]} -gt 0 ]; then
        echo "✅ Found ${#DETECTED_SMB_HOSTS[@]} SMB hosts:"
        for i in "${!DETECTED_SMB_HOSTS[@]}"; do
            echo "   $((i+1)). ${DETECTED_SMB_HOSTS[$i]}"
        done
        
        # Set the first detected host as the current host
        if [ -z "$ROCKNIX_HOST" ]; then
            ROCKNIX_HOST="${DETECTED_SMB_HOSTS[0]}"
            echo "✅ Set current RockNix host to: $ROCKNIX_HOST"
        fi
    else
        echo "❌ No SMB hosts found on the network."
    fi
    
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
    fi
    
    # Check if we have SMB hosts detected
    if [ ${#DETECTED_SMB_HOSTS[@]} -gt 0 ]; then
        # Transfer to all hosts in parallel without asking
        echo "🔄 Automatically transferring ROM to all detected RockNix hosts (${#DETECTED_SMB_HOSTS[@]} hosts)..."
        
        # Array to track transfer processes
        transfer_pids=()
        transfer_hosts=()
        
        # Determine destination directory
        local dest_dir="$ROCKNIX_ROMS_PATH/$platform"
        
        # Start transfers in background
        for host in "${DETECTED_SMB_HOSTS[@]}"; do
            echo "Starting transfer to $host..."
            
            # Create the directory if it doesn't exist (in background)
            (
                sshpass -p "$ROCKNIX_PASS" ssh -o StrictHostKeyChecking=no "$ROCKNIX_USER@$host" "mkdir -p $dest_dir" 2>/dev/null
                
                # Transfer the file
                echo "Transferring file to $host:$dest_dir..."
                if sshpass -p "$ROCKNIX_PASS" scp -o StrictHostKeyChecking=no "$rom_path" "$ROCKNIX_USER@$host:$dest_dir/"; then
                    echo "✅ File transferred successfully to $host!"
                else
                    echo "❌ File transfer failed to $host."
                fi
            ) &
            
            # Store the process ID and host
            transfer_pids+=($!)
            transfer_hosts+=("$host")
        done
        
        # Display transfer status
        echo "Transfers started in parallel. Waiting for completion..."
        
        # Wait for all transfers to complete
        for i in "${!transfer_pids[@]}"; do
            echo -n "Waiting for transfer to ${transfer_hosts[$i]} to complete... "
            if wait ${transfer_pids[$i]}; then
                echo "✅ Done!"
            else
                echo "❌ Failed!"
            fi
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
        sshpass -p "$ROCKNIX_PASS" ssh -o StrictHostKeyChecking=no "$ROCKNIX_USER@$host" "ls -la /storage/roms" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo "✅ Successfully connected to $host"
            # Update the ROCKNIX_HOST variable to use this host for future operations
            ROCKNIX_HOST="$host"
            echo "Available ROMs on $host:"
            sshpass -p "$ROCKNIX_PASS" ssh -o StrictHostKeyChecking=no "$ROCKNIX_USER@$host" "ls -la /storage/roms"
            
            # Ask if user wants to transfer files
            echo ""
            read -p "Do you want to transfer files to this host? (y/n): " transfer_choice
            if [[ "$transfer_choice" == "y" || "$transfer_choice" == "Y" ]]; then
                transfer_files_to_host "$host"
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
    echo "Enter the destination directory on the remote host (e.g., /storage/roms/NES):"
    read -e dest_dir
    
    # Default to /storage/roms if empty
    if [ -z "$dest_dir" ]; then
        dest_dir="$ROCKNIX_ROMS_PATH"
    fi
    
    # Create the directory if it doesn't exist
    sshpass -p "$ROCKNIX_PASS" ssh -o StrictHostKeyChecking=no "$ROCKNIX_USER@$host" "mkdir -p $dest_dir" 2>/dev/null
    
    # Transfer the file
    echo "Transferring file to $host:$dest_dir..."
    sshpass -p "$ROCKNIX_PASS" scp -o StrictHostKeyChecking=no "$file_path" "$ROCKNIX_USER@$host:$dest_dir/"
    
    if [ $? -eq 0 ]; then
        echo "✅ File transferred successfully!"
    else
        echo "❌ File transfer failed."
    fi
    
    read -p "Press Enter to continue..."
    return 0
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

# Function to show menu
show_menu() {
    clear
    echo "===== ROM Downloader ====="
    echo "Current Platform: $(to_uppercase $CURRENT_PLATFORM)"
    echo "============================="
    echo "Select a platform or option (use ↑↓ arrows, press Enter to select):"
    echo "-----------------------------------------------------"
    
    local menu_options=(
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
        "GG (Sega Game Gear)"
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
    
    menu_select "${menu_options[@]}"
    choice=$?
    
    # Convert choice 20 (Exit) to 0 for compatibility
    if [ "$choice" -eq 20 ]; then
        choice=0
    fi
}

# Function to show more menu
show_more_menu() {
    clear
    echo "===== More Options ====="
    echo "Select an option (use ↑↓ arrows, press Enter to select):"
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
            clear
            echo "===== Connect to SMB ====="
            show_smb_menu
            ;;
        2)
            clear
            echo "===== Download All ROMs ====="
            echo "Continue? (use ↑↓ arrows, press Enter to select)"
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
        echo "Use arrow keys or enter number to select a ROM to download or return to main menu"
        echo "-----------------------------------------------------"
        
        # Add "Return to Main Menu" as the last option
        local display_options=("${filtered_roms[@]}" "Return to Main Menu")
        
        # Display ROMs with arrow key selection and numbers
        menu_select "${display_options[@]}"
        local selected=$?
        
        # Check if user selected the last option (Return to Main Menu)
        if [ $selected -eq ${#display_options[@]} ]; then
            echo "Returning to main menu..."
            break
        # Check if user pressed ESC (selected will be 0)
        elif [ $selected -eq 0 ]; then
            echo "Returning to main menu..."
            break
        fi
        
        # Download the selected ROM without asking for confirmation
        local selected_rom="${display_options[$((selected-1))]}"
        
        # Download the ROM immediately
        download_rom "$selected_rom" "$platform"
        
        # Brief pause to let user see the download completed
        sleep 1
        
        # Continue the loop to allow selecting another ROM
        # No additional prompts - just go back to the ROM selection list
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
    clear
    echo "===== Transfer File to Multiple Hosts ====="
    
    # Check if we have detected hosts
    if [ ${#DETECTED_SMB_HOSTS[@]} -eq 0 ]; then
        echo "No SMB hosts detected. Running scan first..."
        scan_for_smb_hosts
        
        if [ ${#DETECTED_SMB_HOSTS[@]} -eq 0 ]; then
            echo "❌ No SMB hosts found. Cannot proceed with transfer."
            read -p "Press Enter to continue..."
            return 1
        fi
    fi
    
    # Display available hosts and let user select which ones to use
    echo "Select hosts to transfer to (space-separated numbers, e.g., '1 3'):"
    for i in "${!DETECTED_SMB_HOSTS[@]}"; do
        echo "$((i+1)). ${DETECTED_SMB_HOSTS[$i]}"
    done
    
    read -p "Enter host numbers (or 'all' for all hosts): " host_selection
    
    # Process host selection
    selected_hosts=()
    
    if [[ "$host_selection" == "all" ]]; then
        # Use all detected hosts
        selected_hosts=("${DETECTED_SMB_HOSTS[@]}")
    else
        # Parse the space-separated numbers
        for num in $host_selection; do
            if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le ${#DETECTED_SMB_HOSTS[@]} ]; then
                selected_hosts+=("${DETECTED_SMB_HOSTS[$((num-1))]}")
            fi
        done
    fi
    
    # Check if we have any selected hosts
    if [ ${#selected_hosts[@]} -eq 0 ]; then
        echo "❌ No valid hosts selected."
        read -p "Press Enter to continue..."
        return 1
    fi
    
    echo "Selected ${#selected_hosts[@]} hosts for transfer."
    
    # Get file to transfer
    echo "Enter the full path to the file you want to transfer:"
    read -e file_path
    
    if [ ! -f "$file_path" ]; then
        echo "❌ File not found: $file_path"
        read -p "Press Enter to continue..."
        return 1
    fi
    
    # Get destination directory
    echo "Enter the destination directory on the remote hosts (e.g., /storage/roms/gb):"
    read -e dest_dir
    
    # Default to /storage/roms if empty
    if [ -z "$dest_dir" ]; then
        dest_dir="$ROCKNIX_ROMS_PATH"
    fi
    
    # Transfer to all selected hosts in parallel
    echo "Transferring file to ${#selected_hosts[@]} hosts simultaneously..."
    
    # Array to track transfer processes
    transfer_pids=()
    transfer_hosts=()
    
    # Start transfers in background
    for host in "${selected_hosts[@]}"; do
        echo "Starting transfer to $host..."
        
        # Create the directory if it doesn't exist (in background)
        (
            sshpass -p "$ROCKNIX_PASS" ssh -o StrictHostKeyChecking=no "$ROCKNIX_USER@$host" "mkdir -p $dest_dir" 2>/dev/null
            
            # Transfer the file
            echo "Transferring file to $host:$dest_dir..."
            if sshpass -p "$ROCKNIX_PASS" scp -o StrictHostKeyChecking=no "$file_path" "$ROCKNIX_USER@$host:$dest_dir/"; then
                echo "✅ File transferred successfully to $host!"
            else
                echo "❌ File transfer failed to $host."
            fi
        ) &
        
        # Store the process ID and host
        transfer_pids+=($!)
        transfer_hosts+=("$host")
    done
    
    # Display transfer status
    echo "Transfers started in parallel. Waiting for completion..."
    
    # Wait for all transfers to complete
    for i in "${!transfer_pids[@]}"; do
        echo -n "Waiting for transfer to ${transfer_hosts[$i]} to complete... "
        if wait ${transfer_pids[$i]}; then
            echo "✅ Done!"
        else
            echo "❌ Failed!"
        fi
    done
    
    echo "All transfers completed."
    read -p "Press Enter to continue..."
    return 0
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
        
        # Handle platform selection (choices 1-18)
        if [ "$choice" -ge 1 ] && [ "$choice" -le 18 ]; then
            case $choice in
                1) CURRENT_PLATFORM="nes";;
                2) CURRENT_PLATFORM="snes";;
                3) CURRENT_PLATFORM="gb";;
                4) CURRENT_PLATFORM="gba";;
                5) CURRENT_PLATFORM="gbc";;
                6) CURRENT_PLATFORM="sms";;
                7) CURRENT_PLATFORM="genesis";;
                8) CURRENT_PLATFORM="segacd";;
                9) CURRENT_PLATFORM="sega32x";;
                10) CURRENT_PLATFORM="saturn";;
                11) CURRENT_PLATFORM="gg";;
                12) CURRENT_PLATFORM="ngp";;
                13) CURRENT_PLATFORM="tg16";;
                14) CURRENT_PLATFORM="tgcd";;
                15) CURRENT_PLATFORM="ps1";;
                16) CURRENT_PLATFORM="ps2";;
                17) CURRENT_PLATFORM="n64";;
                18) CURRENT_PLATFORM="lynx";;
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
            19)
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

# Clean up on exit
trap "rm -f $TEMP_FILE; tput cnorm" EXIT INT TERM

# Start the main menu
main_menu
