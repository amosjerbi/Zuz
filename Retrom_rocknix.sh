#!/bin/bash

# Set variables
CURRENT_PLATFORM=""
DEFAULT_ROMS_BASE_DIR="/Volumes/games-roms/"
ROMS_BASE_DIR="$DEFAULT_ROMS_BASE_DIR"

# Check for command line argument for ROMS_BASE_DIR
if [ -n "$1" ]; then
    ROMS_BASE_DIR="$1"
fi

NES_DIR="$ROMS_BASE_DIR/nes"
SNES_DIR="$ROMS_BASE_DIR/snes"
GENESIS_DIR="$ROMS_BASE_DIR/genesis"
GB_DIR="$ROMS_BASE_DIR/gb"
GBA_DIR="$ROMS_BASE_DIR/gba"
GBC_DIR="$ROMS_BASE_DIR/gbc"
GAMEGEAR_DIR="$ROMS_BASE_DIR/gamegear"
NGP_DIR="$ROMS_BASE_DIR/ngp"
SMS_DIR="$ROMS_BASE_DIR/mastersystem"
SEGACD_DIR="$ROMS_BASE_DIR/segacd"
SEGA32X_DIR="$ROMS_BASE_DIR/sega32x"
SATURN_DIR="$ROMS_BASE_DIR/saturn"
TG16_DIR="$ROMS_BASE_DIR/tg16"
TGCD_DIR="$ROMS_BASE_DIR/tgcd"
PS1_DIR="$ROMS_BASE_DIR/ps1"
PS2_DIR="$ROMS_BASE_DIR/ps2"
N64_DIR="$ROMS_BASE_DIR/n64"
DREAMCAST_DIR="$ROMS_BASE_DIR/dreamcast"
LYNX_DIR="$ROMS_BASE_DIR/lynx"
TEMP_FILE="/tmp/rom_list.txt"

# Define function to get archive URL for a platform
get_archive_url() {
    local platform="$1"
    
    case "$platform" in
        "nes")
            echo "https://archive.org/download/nes-collection"
            ;;
        "snes")
            echo "https://archive.org/download/SuperNintendofull_rom_pack"
            ;;
        "genesis")
            echo "https://archive.org/download/sega-genesis-romset-ultra-usa"
            ;;
        "gb")
            echo "https://archive.org/download/GameBoy-Romset-by-LoLLo"
            ;;
        "gba")
            echo "https://archive.org/download/GameboyAdvanceRomCollectionByGhostware"
            ;;
        "gbc")
            echo "https://archive.org/download/GameBoyColor"
            ;;
        "gg")
            echo "https://archive.org/download/sega-game-gear-romset-ultra-us"
            ;;
        "ngp")
            echo "https://archive.org/download/neogeopocketromcollectionmm1000"
            ;;
        "sms")
            echo "https://archive.org/download/sega-master-system-romset-ultra-us"
            ;;
        "segacd")
            echo "https://archive.org/download/cylums-sega-cd-rom-collection/Cylum%27s%20Sega%20CD%20ROM%20Collection%20%2802-19-2021%29/"
            ;;
        "sega32x")
            echo "https://ia903400.us.archive.org/view_archive.php?archive=/30/items/cylums-sega-32-x-rom-collection/Cylum%27s%20Sega%2032X%20ROM%20Collection%20%2802-14-2021%29.zip"
            ;;
        "saturn")
            echo "https://archive.org/download/sega-saturn-romset"
            ;;
        "tg16")
            echo "https://ia903409.us.archive.org/view_archive.php?archive=/0/items/cylums-turbo-grafx-16-rom-collection/Cylum%27s%20TurboGrafx-16%20ROM%20Collection%20%2802-14-2021%29.zip"
            ;;
        "tgcd")
            echo "https://archive.org/download/redump.nec_pcecd-tgcd"
            ;;
        "ps1")
            echo "https://archive.org/download/Centuron-PSX"
            ;;
        "ps2")
            echo "https://archive.org/download/asurah94ps2_202405"
            ;;
        "n64")
            echo "https://archive.org/download/unrenamed-consoles-n64/UnRenamed%20Consoles%20-%20NINTENDO-N64/"
            ;;
        "dreamcast")
            echo "https://archive.org/download/sega-dreamcast-romset"
            ;;
        "lynx")
            echo "https://archive.org/download/AtariLynxRomCollectionByGhostware"
            ;;
        *)
            echo ""
            ;;
    esac
}

# Function to get platform directory
get_platform_dir() {
    local platform="$1"
    
    case "$platform" in
        "nes")
            echo "$NES_DIR"
            ;;
        "snes")
            echo "$SNES_DIR"
            ;;
        "genesis")
            echo "$GENESIS_DIR"
            ;;
        "gb")
            echo "$GB_DIR"
            ;;
        "gba")
            echo "$GBA_DIR"
            ;;
        "gbc")
            echo "$GBC_DIR"
            ;;
        "gg")
            echo "$GAMEGEAR_DIR"
            ;;
        "ngp")
            echo "$NGP_DIR"
            ;;
        "sms")
            echo "$SMS_DIR"
            ;;
        "segacd")
            echo "$SEGACD_DIR"
            ;;
        "sega32x")
            echo "$SEGA32X_DIR"
            ;;
        "saturn")
            echo "$SATURN_DIR"
            ;;
        "tg16")
            echo "$TG16_DIR"
            ;;
        "tgcd")
            echo "$TGCD_DIR"
            ;;
        "ps1")
            echo "$PS1_DIR"
            ;;
        "ps2")
            echo "$PS2_DIR"
            ;;
        "n64")
            echo "$N64_DIR"
            ;;
        "dreamcast")
            echo "$DREAMCAST_DIR"
            ;;
        "lynx")
            echo "$LYNX_DIR"
            ;;
        *)
            echo "$ROMS_BASE_DIR/$platform"
            ;;
    esac
}

# Function to decode URL-encoded strings
urldecode() {
    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}

# Function to convert to uppercase
to_uppercase() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

# Function to open the ROMs folder
open_roms_folder() {
    # Check if the base directory exists
    if [ ! -d "$ROMS_BASE_DIR" ]; then
        echo "The ROM directory $ROMS_BASE_DIR does not exist."
        return 1
    fi

    # Open the directory based on the OS
    case "$(uname)" in
        "Darwin") # macOS
            open "$ROMS_BASE_DIR"
            ;;
        "Linux")
            if command -v xdg-open > /dev/null; then
                xdg-open "$ROMS_BASE_DIR"
            else
                echo "Cannot open directory. xdg-open not found."
                return 1
            fi
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

    # Save current cursor position and hide it
    tput sc
    tput civis

    # Function to draw menu
    draw_menu() {
        # Restore cursor position and clear below
        tput rc
        tput ed
        
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
                tput cnorm  # Show cursor
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
                tput cnorm  # Show cursor
                echo
                return $((selected + 1))
                ;;
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
        "DREAMCAST (Sega Dreamcast)"
        "LYNX (Atari Lynx)"
    )
    
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
            CURRENT_PLATFORM="dreamcast"
            echo "Selected platform: Sega Dreamcast"
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

# Function to show menu
show_menu() {
    clear
    echo "===== ROM Downloader ====="
    echo "Current Platform: $(to_uppercase $CURRENT_PLATFORM)"
    echo "============================="
    echo "Select an option (use ↑↓ arrows, press Enter to select):"
    echo "-----------------------------------------------------"
    
    local menu_options=(
        "Search ROMs"
        "List All ROMs"
        "Download All ROMs"
        "Open ROMs Folder"
        "Verify ROM Directories"
        "Copy ROMs to External Drive"
        "Exit"
    )
    
    menu_select "${menu_options[@]}"
    choice=$?
    
    # Convert choice 7 (Exit) to 0 for compatibility
    if [ "$choice" -eq 7 ]; then
        choice=0
    fi
}

# Function to list available platforms
list_platforms() {
    clear
    echo "===== Available Platforms ====="
    
    # Explicitly list all platforms with their URLs
    local i=1
    local platforms_array=("nes" "snes" "gb" "gba" "gbc" "sms" "genesis" "segacd" "sega32x" "saturn" "gg" "ngp" "tg16" "tgcd" "ps1" "ps2" "n64" "dreamcast" "lynx")
    local descriptions=(
        "Nintendo Entertainment System"
        "Super Nintendo Entertainment System"
        "Game Boy"
        "Game Boy Advance"
        "Game Boy Color"
        "Sega Master System"
        "Sega Genesis"
        "Sega CD"
        "Sega 32X"
        "Sega Saturn"
        "Sega Game Gear"
        "Neo Geo Pocket"
        "TurboGrafx-16"
        "TurboGrafx-CD"
        "PlayStation"
        "PlayStation 2"
        "Nintendo 64"
        "Sega Dreamcast"
        "Atari Lynx"
    )
    
    # Display platforms
    for ((i=0; i<${#platforms_array[@]}; i++)); do
        platform="${platforms_array[$i]}"
        description="${descriptions[$i]}"
        echo "$((i+1)). $(to_uppercase $platform) - $description"
        echo "   URL: $(get_archive_url $platform)"
    done
    
    echo "============================="
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
    
    # If platform is not provided, use the current platform
    if [ -z "$platform" ]; then
        platform="$CURRENT_PLATFORM"
    fi
    
    # Get the archive URL from the function
    local archive_url=$(get_archive_url "$platform")
    
    if [ -z "$archive_url" ]; then
        echo "Error: No archive URL found for platform $(to_uppercase $platform)"
        return 1
    fi
    
    # Extract just the filename without extension for display
    local rom_name=$(basename "$rom_file")
    local decoded_rom_name=$(urldecode "$rom_name")
    
    echo "Downloading ROM: $decoded_rom_name"
    echo "Platform: $(to_uppercase $platform)"
    
    # Get the correct platform directory
    local platform_dir=$(get_platform_dir "$platform")
    
    echo "ROM will be saved to: $platform_dir"
    
    # URL encode the ROM file for downloading
    local encoded_rom_file=$(echo "$rom_file" | sed 's/ /%20/g')
    
    # Construct the full download URL
    local download_url="${archive_url}/${encoded_rom_file}"
    echo "Download URL: $download_url"
    
    # Create platform directory if it doesn't exist
    mkdir -p "$platform_dir"
    
    # Download the ROM file
    curl -s -L -o "$platform_dir/$decoded_rom_name" "$download_url"
    local download_status=$?
    
    # For PS1 platform, also download the corresponding .bin file if we're downloading a .cue file
    if [ "$platform" = "ps1" ] && [[ "$rom_file" == *".cue" ]]; then
        local bin_file="${rom_file%.cue}.bin"
        local encoded_bin_file=$(echo "$bin_file" | sed 's/ /%20/g')
        local bin_download_url="${archive_url}/${encoded_bin_file}"
        local decoded_bin_name=$(urldecode "$(basename "$bin_file")")
        
        echo "Also downloading corresponding .bin file: $decoded_bin_name"
        curl -s -L -o "$platform_dir/$decoded_bin_name" "$bin_download_url"
        
        if [ $? -eq 0 ]; then
            echo ".bin file download successful!"
        else
            echo "Error downloading .bin file. You may need to download it manually."
        fi
    fi
    
    if [ $download_status -eq 0 ]; then
        echo "Download successful!"
        echo "ROM saved to: $platform_dir/$decoded_rom_name"
    else
        echo "Error downloading ROM. Please try again."
    fi
    
    # No 'Press Enter to continue' here - let the calling function handle the flow
}

# Function to download all ROMs for a platform
download_all_roms() {
    local platform="$CURRENT_PLATFORM"
    
    # Get the archive URL from the function
    local archive_url=$(get_archive_url "$platform")
    
    if [ -z "$archive_url" ]; then
        echo "Error: No archive URL found for platform $(to_uppercase $platform)"
        read -p "Press Enter to continue..."
        return 1
    fi
    
    echo "Downloading all ROMs for $(to_uppercase $platform) platform..."
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
    
    # Filter ROMs based on platform
    local filtered_roms=()
    local rom_name
    
    while IFS= read -r rom_name; do
        # Decode URL-encoded names
        rom_name=$(urldecode "$rom_name")
        
        # If we're dealing with a specific platform, filter the results
        case "$platform" in
            "nes")
                if echo "$rom_name" | grep -qi "nes\|nintendo\|famicom"; then
                    filtered_roms+=("$rom_name")
                fi
                ;;
            "snes")
                if echo "$rom_name" | grep -qi "snes\|super\|sfc"; then
                    filtered_roms+=("$rom_name")
                fi
                ;;
            "genesis")
                if echo "$rom_name" | grep -qi "genesis\|mega\|sega\|32x\|md\|gen"; then
                    filtered_roms+=("$rom_name")
                fi
                ;;
            "gb")
                if echo "$rom_name" | grep -qi "gameboy\|game boy\|gb\|gbc"; then
                    filtered_roms+=("$rom_name")
                fi
                ;;
            "gba")
                if echo "$rom_name" | grep -qi "advance\|gba"; then
                    filtered_roms+=("$rom_name")
                fi
                ;;
            "gg")
                if echo "$rom_name" | grep -qi "gamegear\|gg"; then
                    filtered_roms+=("$rom_name")
                fi
                ;;
            "ngp")
                if echo "$rom_name" | grep -qi "neogeo\|ngp"; then
                    filtered_roms+=("$rom_name")
                fi
                ;;
            "sms")
                if echo "$rom_name" | grep -qi "master system\|mastersystem\|sms"; then
                    filtered_roms+=("$rom_name")
                fi
                ;;
            "gbc")
                if echo "$rom_name" | grep -qi "gameboy\|color\|gbc"; then
                    filtered_roms+=("$rom_name")
                fi
                ;;
            "ps1")
                if echo "$rom_name" | grep -qi "playstation\|ps1\|psx"; then
                    filtered_roms+=("$rom_name")
                fi
                ;;
        esac
    done < "$rom_list_file"
    
    # Remove temporary file
    rm -f "$rom_list_file"
    
    # Ask for confirmation before downloading all ROMs
    read -p "Do you want to download all ${#filtered_roms[@]} ROMs? (y/n): " confirm
    
    if [ "$confirm" != "y" ]; then
        echo "Download canceled."
        read -p "Press Enter to continue..."
        return 0
    fi
    
    # Get the correct platform directory
    local platform_dir=$(get_platform_dir "$platform")
    
    echo "Downloading ROMs to $platform_dir..."
    
    # Download each ROM
    local i=1
    for rom_file in "${filtered_roms[@]}"; do
        echo "Downloading ROM $i/${#filtered_roms[@]}: $rom_file"
        
        # Extract just the filename without path
        local filename=$(basename "$rom_file")
        
        # Download the ROM
        curl -s -L "$archive_url/$rom_file" -o "$platform_dir/$filename"
        
        # Check if download was successful
        if [ $? -eq 0 ]; then
            echo "✓ Downloaded: $filename"
        else
            echo "✗ Failed to download: $filename"
        fi
        
        ((i++))
        
        # Add a small delay between downloads to avoid overwhelming the server
        sleep 1
    done
    
    echo "Download complete. ${#filtered_roms[@]} ROMs downloaded to $platform_dir"
    
    read -p "Press Enter to continue..."
    return 0
}

# Function to verify ROM directories
verify_rom_directories() {
    local all_ok=true
    
    # Check if base directory exists
    if [ ! -d "$ROMS_BASE_DIR" ]; then
        echo "The ROM directory $ROMS_BASE_DIR does not exist."
        all_ok=false
    fi
    
    # Check platform directories
    for platform in nes snes genesis gb gba gbc gamegear ngp mastersystem segacd sega32x saturn tg16 tgcd ps1 ps2 n64 dreamcast lynx; do
        local dir=$(get_platform_dir "$platform")
        if [ ! -d "$dir" ]; then
            echo "Platform directory $dir does not exist."
            all_ok=false
        fi
    done
    
    if $all_ok; then
        echo "All ROM directories exist."
    fi
}

# Function to test archive URLs
test_archive_urls() {
    clear
    echo "===== Testing Archive URLs ====="
    
    for platform in "nes" "snes" "gb" "gba" "gbc" "sms" "genesis" "segacd" "sega32x" "saturn" "gg" "ngp" "tg16" "tgcd" "ps1" "ps2" "n64" "dreamcast" "lynx"; do
        local archive_url=$(get_archive_url "$platform")
        
        echo "Testing $(to_uppercase $platform) URL: $archive_url"
        local http_code=$(curl -s -o /dev/null -w "%{http_code}" "$archive_url")
        
        if [ "$http_code" -eq 200 ]; then
            echo "✅ $(to_uppercase $platform) archive is accessible (HTTP $http_code)"
        else
            echo "❌ $(to_uppercase $platform) archive is NOT accessible (HTTP $http_code)"
            
            # Since we're now using the associative array consistently,
            # there are no alternative URLs to try
            echo "   No alternative URL available."
        fi
        echo ""
    done
    
    echo "URL testing complete."
    read -p "Press Enter to continue..."
}

# Function to copy ROMs to external drive
copy_roms_to_external() {
    echo "Enter the path to the external drive:"
    read -r external_path
    
    if [ ! -d "$external_path" ]; then
        echo "Directory $external_path does not exist."
        return 1
    fi
    
    if [ ! -w "$external_path" ]; then
        echo "No write permission for $external_path"
        return 1
    fi
    
    # Copy each platform's ROMs
    for platform in "nes" "snes" "genesis" "gb" "gba" "gg" "ngp" "sms"; do
        local src_dir="$ROMS_BASE_DIR/$platform"
        local dst_dir="$external_path/$platform"
        
        if [ -d "$src_dir" ]; then
            echo "Copying $platform ROMs..."
            mkdir -p "$dst_dir"
            
            # Use rsync if available for better performance and resume capability
            if command -v rsync >/dev/null 2>&1; then
                rsync -av "$src_dir/" "$dst_dir/"
            else
                # Fallback to cp if rsync is not available
                cp -R "$src_dir/"* "$dst_dir/" 2>/dev/null || true
            fi
            
            if [ $? -eq 0 ]; then
                echo "Successfully copied $platform ROMs to $dst_dir"
            else
                echo "Failed to copy some or all $platform ROMs"
            fi
        else
            echo "No $platform ROMs found in $src_dir"
        fi
    done
    
    echo "ROM copying process completed."
    read -p "Press Enter to continue..."
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
        
        case $choice in
            1)
                clear
                echo "===== Search ROMs ====="
                select_platform
                read -p "Enter search term: " search_term
                if [ -n "$search_term" ]; then
                    clear
                    search_roms "$search_term" "$CURRENT_PLATFORM"
                fi
                ;;
            2)
                clear
                echo "===== List All ROMs ====="
                select_platform
                search_roms "" "$CURRENT_PLATFORM"
                ;;
            3)
                clear
                echo "===== Download All ROMs ====="
                select_platform
                
                echo "Continue? (use ↑↓ arrows, press Enter to select)"
                echo "-----------------------------------------------------"
                local confirm_options=("Yes" "No")
                menu_select "${confirm_options[@]}"
                local confirm_choice=$?
                
                if [ "$confirm_choice" -eq 1 ]; then
                    download_all_roms "$CURRENT_PLATFORM"
                    read -p "Press Enter to continue..."
                fi
                ;;
            4)
                clear
                echo "===== Open ROMs Folder ====="
                select_platform
                open_roms_folder
                read -p "Press Enter to continue..."
                ;;
            5)
                clear
                echo "===== Verify ROM Directories ====="
                verify_rom_directories
                ;;
            6)
                clear
                echo "===== Copy ROMs to External Drive ====="
                copy_roms_to_external
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
