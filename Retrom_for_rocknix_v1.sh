#!/bin/bash

# Set variables
CURRENT_PLATFORM=""
DEFAULT_ROMS_BASE_DIR="$HOME/Desktop/$(whoami)/games-roms"
ROMS_BASE_DIR="$DEFAULT_ROMS_BASE_DIR"

# Check if DEFAULT_ROMS_BASE_DIR exists
if [ -d "$DEFAULT_ROMS_BASE_DIR" ]; then
    echo "Default ROMs directory exists at: $DEFAULT_ROMS_BASE_DIR"
else
    echo "Default ROMs directory does not exist at: $DEFAULT_ROMS_BASE_DIR"
    echo "Do you want to create it? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        if ! mkdir -p "$DEFAULT_ROMS_BASE_DIR"; then
            echo "Cannot create default directory $DEFAULT_ROMS_BASE_DIR. Please check permissions."
            exit 1
        else
            echo "Default ROMs directory created at: $DEFAULT_ROMS_BASE_DIR"
        fi
    else
        echo "Default ROMs directory not created. Using current directory instead."
        ROMS_BASE_DIR="$(pwd)"
    fi
fi

# Function to set ROM base directory
set_roms_base_dir() {
    echo "Current ROMs directory: $ROMS_BASE_DIR"
    echo "Do you want to change the ROMs directory? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "Enter new ROMs directory path:"
        read -r new_dir
        if [ -n "$new_dir" ]; then
            ROMS_BASE_DIR="$new_dir"
            echo "ROMs directory changed to: $ROMS_BASE_DIR"
            # Update all platform directories
            NES_DIR="$ROMS_BASE_DIR/nes"
            SNES_DIR="$ROMS_BASE_DIR/snes"
            GENESIS_DIR="$ROMS_BASE_DIR/genesis"
            GB_DIR="$ROMS_BASE_DIR/gb"
            GBA_DIR="$ROMS_BASE_DIR/gba"
            GAMEGEAR_DIR="$ROMS_BASE_DIR/gamegear"
            NGP_DIR="$ROMS_BASE_DIR/ngp"
            SMS_DIR="$ROMS_BASE_DIR/mastersystem"
        fi
    fi
}

# Check for command line argument for ROMS_BASE_DIR
if [ -n "$1" ]; then
    ROMS_BASE_DIR="$1"
fi

NES_DIR="$ROMS_BASE_DIR/nes"
SNES_DIR="$ROMS_BASE_DIR/snes"
GENESIS_DIR="$ROMS_BASE_DIR/genesis"
GB_DIR="$ROMS_BASE_DIR/gb"
GBA_DIR="$ROMS_BASE_DIR/gba"
GAMEGEAR_DIR="$ROMS_BASE_DIR/gamegear"
NGP_DIR="$ROMS_BASE_DIR/ngp"
SMS_DIR="$ROMS_BASE_DIR/mastersystem"
TEMP_FILE="/tmp/rom_list.txt"

# Define platforms with their archive URLs
declare -A ARCHIVE_URLS=(
    ["nes"]="https://archive.org/download/nes-collection"
    ["snes"]="https://archive.org/download/SuperNintendofull_rom_pack"
    ["genesis"]="https://archive.org/download/sega-genesis-romset-ultra-usa"
    ["gb"]="https://archive.org/download/GameBoy-Romset-by-LoLLo"
    ["gba"]="https://archive.org/download/GameboyAdvanceRomCollectionByGhostware"
    ["gg"]="https://archive.org/download/sega-game-gear-romset-ultra-us"
    ["ngp"]="https://archive.org/download/neogeopocketromcollectionmm1000"
    ["sms"]="https://archive.org/download/sega-master-system-romset-ultra-us"
)

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
        "gg")
            echo "$GAMEGEAR_DIR"
            ;;
        "ngp")
            echo "$NGP_DIR"
            ;;
        "sms")
            echo "$SMS_DIR"
            ;;
        *)
            echo "$ROMS_BASE_DIR/$platform"
            ;;
    esac
}

# Create ROM directory if it doesn't exist
if [ ! -d "$ROMS_BASE_DIR" ]; then
    if ! mkdir -p "$ROMS_BASE_DIR"; then
        echo "Cannot create directory $ROMS_BASE_DIR. Please check permissions."
        exit 1
    fi
fi

# Create NES directory if it doesn't exist
if [ ! -d "$NES_DIR" ]; then
    if ! mkdir -p "$NES_DIR"; then
        echo "Cannot create NES directory $NES_DIR. Please check permissions."
        exit 1
    fi
fi

# Create SNES directory if it doesn't exist
if [ ! -d "$SNES_DIR" ]; then
    if ! mkdir -p "$SNES_DIR"; then
        echo "Cannot create SNES directory $SNES_DIR. Please check permissions."
        exit 1
    fi
fi

# Create Genesis directory if it doesn't exist
if [ ! -d "$GENESIS_DIR" ]; then
    if ! mkdir -p "$GENESIS_DIR"; then
        echo "Cannot create Genesis directory $GENESIS_DIR. Please check permissions."
        exit 1
    fi
fi

# Create GB directory if it doesn't exist
if [ ! -d "$GB_DIR" ]; then
    if ! mkdir -p "$GB_DIR"; then
        echo "Cannot create GB directory $GB_DIR. Please check permissions."
        exit 1
    fi
fi

# Create GBA directory if it doesn't exist
if [ ! -d "$GBA_DIR" ]; then
    if ! mkdir -p "$GBA_DIR"; then
        echo "Cannot create GBA directory $GBA_DIR. Please check permissions."
        exit 1
    fi
fi

# Create GG directory if it doesn't exist
if [ ! -d "$GAMEGEAR_DIR" ]; then
    if ! mkdir -p "$GAMEGEAR_DIR"; then
        echo "Cannot create GG directory $GAMEGEAR_DIR. Please check permissions."
        exit 1
    fi
fi

# Create NGP directory if it doesn't exist
if [ ! -d "$NGP_DIR" ]; then
    if ! mkdir -p "$NGP_DIR"; then
        echo "Cannot create NGP directory $NGP_DIR. Please check permissions."
        exit 1
    fi
fi

# Create SMS directory if it doesn't exist
if [ ! -d "$SMS_DIR" ]; then
    if ! mkdir -p "$SMS_DIR"; then
        echo "Cannot create Master System directory $SMS_DIR. Please check permissions."
        exit 1
    fi
fi

# Check if directories are writable
if [ ! -w "$ROMS_BASE_DIR" ]; then
    echo "$ROMS_BASE_DIR is not writable"
    exit 1
fi

if [ ! -w "$NES_DIR" ]; then
    echo "$NES_DIR is not writable"
    exit 1
fi

if [ ! -w "$SNES_DIR" ]; then
    echo "$SNES_DIR is not writable"
    exit 1
fi

if [ ! -w "$GENESIS_DIR" ]; then
    echo "$GENESIS_DIR is not writable"
    exit 1
fi

if [ ! -w "$GB_DIR" ]; then
    echo "$GB_DIR is not writable"
    exit 1
fi

if [ ! -w "$GBA_DIR" ]; then
    echo "$GBA_DIR is not writable"
    exit 1
fi

if [ ! -w "$GAMEGEAR_DIR" ]; then
    echo "$GAMEGEAR_DIR is not writable"
    exit 1
fi

if [ ! -w "$NGP_DIR" ]; then
    echo "$NGP_DIR is not writable"
    exit 1
fi

if [ ! -w "$SMS_DIR" ]; then
    echo "$SMS_DIR is not writable"
    exit 1
fi

# Function to decode URL-encoded strings
urldecode() {
    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}

# Function to convert to uppercase
to_uppercase() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

# Create the destination directory if it doesn't exist
mkdir -p "$ROMS_BASE_DIR"

# Function to open the ROMs folder
open_roms_folder() {
    local platform_dir=$(get_platform_dir "$CURRENT_PLATFORM")
    
    # Create directory if it doesn't exist
    mkdir -p "$platform_dir"
    
    # Open the directory
    if [ "$(uname)" == "Darwin" ]; then
        # macOS
        open "$platform_dir"
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        # Linux
        if command -v xdg-open > /dev/null; then
            xdg-open "$platform_dir"
        else
            echo "Cannot open folder: xdg-open not available"
        fi
    else
        echo "Cannot open folder: Unsupported operating system"
    fi
}

# Function to select a platform
select_platform() {
    echo "Select a platform:"
    echo "1. NES (Nintendo Entertainment System)"
    echo "2. SNES (Super Nintendo)"
    echo "3. GB (Game Boy)"
    echo "4. GBA (Game Boy Advance)"
    echo "5. SMS (Sega Master System)"
    echo "6. Genesis (Sega Genesis)"
    echo "7. GG (Sega Game Gear)"
    echo "8. NGP (Neo Geo Pocket)"
    
    read -p "Enter your choice (1-8): " platform_choice
    
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
            CURRENT_PLATFORM="sms"
            echo "Selected platform: Sega Master System"
            ;;
        6)
            CURRENT_PLATFORM="genesis"
            echo "Selected platform: Genesis"
            ;;
        7)
            CURRENT_PLATFORM="gg"
            echo "Selected platform: Sega Game Gear"
            ;;
        8)
            CURRENT_PLATFORM="ngp"
            echo "Selected platform: Neo Geo Pocket"
            ;;
        *)
            echo "Invalid choice. Using default platform: Genesis"
            CURRENT_PLATFORM="genesis"
            ;;
    esac
}

# Function to list available platforms
list_platforms() {
    clear
    echo "===== Available Platforms ====="
    
    # Explicitly list all platforms with their URLs
    local i=1
    local platforms_array=("nes" "snes" "gb" "gba" "sms" "genesis" "gg" "ngp")
    local descriptions=(
        "Nintendo Entertainment System"
        "Super Nintendo Entertainment System"
        "Game Boy"
        "Game Boy Advance"
        "Sega Master System"
        "Sega Genesis"
        "Sega Game Gear"
        "Neo Geo Pocket"
    )
    
    # Display platforms
    for ((i=0; i<${#platforms_array[@]}; i++)); do
        platform="${platforms_array[$i]}"
        description="${descriptions[$i]}"
        echo "$((i+1)). $(to_uppercase $platform) - $description"
        echo "   URL: ${ARCHIVE_URLS[$platform]}"
    done
    
    echo "============================="
    read -p "Press Enter to continue..."
}

# Function to display a menu
show_menu() {
    clear
    echo "===== ROM Downloader ====="
    echo "Current Platform: $(to_uppercase $CURRENT_PLATFORM)"
    echo "============================="
    echo "1. Search ROMs"
    echo "2. List All ROMs"
    echo "3. Download All ROMs"
    echo "4. Open ROMs Folder"
    echo "5. Verify ROM Directories"
    echo "6. Copy ROMs to External Drive"
    echo "0. Exit"
    echo "============================="
}

# Function to search and list ROMs
search_roms() {
    local search_term="$1"
    local platform="$2"
    
    # If platform is not provided, use the current platform
    if [ -z "$platform" ]; then
        platform="$CURRENT_PLATFORM"
    fi
    
    # Debug output
    echo "Debug: Using platform: $platform"
    echo "Debug: CURRENT_PLATFORM is set to: $CURRENT_PLATFORM"
    
    # Get the archive URL from the associative array
    local archive_url="${ARCHIVE_URLS[$platform]}"
    
    if [ -z "$archive_url" ]; then
        echo "Error: No archive URL found for platform $(to_uppercase $platform)"
        read -p "Press Enter to continue..."
        return 1
    fi
    
    echo "Searching for ROMs in $(to_uppercase $platform) platform..."
    echo "Archive URL: $archive_url"
    
    # Get the list of ROMs from the archive
    echo "Fetching initial ROM list..."
    
    # Get all zip files from the archive
    curl -s "$archive_url/" | grep -o '<a href="[^"]*\.zip">' | 
    sed 's/<a href="\([^"]*\)">/\1/' > "$TEMP_FILE"
    
    local initial_count=$(wc -l < "$TEMP_FILE")
    echo "Initial ROM count: $initial_count"
    
    # Save all ROMs before filtering
    cp "$TEMP_FILE" "${TEMP_FILE}.all"
    
    # If we're searching for a specific game, do minimal filtering
    if [ -n "$search_term" ]; then
        echo "Searching for ROMs containing '$search_term' in $(to_uppercase $platform) platform..."
        grep -i "$search_term" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
        
        # If we found results, use them
        local search_count=$(wc -l < "${TEMP_FILE}.filtered")
        if [ "$search_count" -gt 0 ]; then
            mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
        else
            # If no results with direct search, try a more lenient approach
            # For example, "sonic" might be in "Sonic the Hedgehog" or "Sonic & Knuckles"
            echo "No direct matches found, trying more lenient search..."
            
            # Use the original list of all ROMs
            mv "${TEMP_FILE}.all" "$TEMP_FILE"
            
            # Try different variations of the search term
            grep -i "$search_term" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
            
            # If still no results, try to be even more lenient
            search_count=$(wc -l < "${TEMP_FILE}.filtered")
            if [ "$search_count" -eq 0 ]; then
                echo "Still no matches, showing all ROMs for manual selection..."
                mv "${TEMP_FILE}.all" "$TEMP_FILE"
            else
                mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
            fi
        fi
    else
        # Less restrictive platform-specific filtering when not searching for a specific game
        case "$platform" in
            "nes")
                # Try to find NES-specific ROMs
                grep -i "nes\|nintendo\|famicom" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                
                # If we found a good number of NES ROMs, use those
                local nes_count=$(wc -l < "${TEMP_FILE}.filtered")
                if [ "$nes_count" -gt 50 ]; then
                    mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
                else
                    # Otherwise, use all ROMs and just exclude obvious non-NES ones
                    mv "${TEMP_FILE}.all" "$TEMP_FILE"
                    grep -v -i "genesis\|megadrive\|32x\|sega\|gameboy\|gba\|advance\|playstation\|ps1\|ps2\|xbox" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                    mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
                fi
                ;;
            "snes")
                # Try to find SNES-specific ROMs
                grep -i "snes\|super\|sfc" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                
                # If we found a good number of SNES ROMs, use those
                local snes_count=$(wc -l < "${TEMP_FILE}.filtered")
                if [ "$snes_count" -gt 50 ]; then
                    mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
                    # Remove obvious non-SNES games
                    grep -v -i "genesis\|megadrive\|32x\|sega\|gameboy\|gba\|advance\|playstation\|ps1\|ps2\|xbox" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                    mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
                else
                    # Otherwise, use all ROMs and just exclude obvious non-SNES ones
                    mv "${TEMP_FILE}.all" "$TEMP_FILE"
                    grep -v -i "genesis\|megadrive\|32x\|sega\|gameboy\|gba\|advance\|playstation\|ps1\|ps2\|xbox" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                    mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
                fi
                ;;
            "genesis")
                # Try to find Genesis-specific ROMs
                grep -i "genesis\|mega\|sega\|32x\|md\|gen" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                
                # If we found a good number of Genesis ROMs, use those
                local genesis_count=$(wc -l < "${TEMP_FILE}.filtered")
                if [ "$genesis_count" -gt 50 ]; then
                    mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
                    # Remove obvious non-Genesis games
                    grep -v -i "nintendo\|nes\|snes\|famicom\|mario\|zelda\|gameboy\|gba\|advance\|playstation\|ps1\|ps2\|xbox" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                    mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
                else
                    # Otherwise, use all ROMs and just exclude obvious non-Genesis ones
                    mv "${TEMP_FILE}.all" "$TEMP_FILE"
                    grep -v -i "nintendo\|nes\|snes\|famicom\|mario\|zelda\|gameboy\|gba\|advance\|playstation\|ps1\|ps2\|xbox" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                    mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
                fi
                ;;
            "gb")
                # Try to find GB-specific ROMs
                grep -i "gameboy\|game boy\|gb\|gbc" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                
                # If we found a good number of GB ROMs, use those
                local gb_count=$(wc -l < "${TEMP_FILE}.filtered")
                if [ "$gb_count" -gt 50 ]; then
                    mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
                    # Remove GBA games
                    grep -v -i "advance\|gba" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                    mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
                else
                    # Otherwise, use all ROMs and just exclude obvious non-GB ones
                    mv "${TEMP_FILE}.all" "$TEMP_FILE"
                    grep -v -i "genesis\|megadrive\|32x\|sega\|advance\|gba\|playstation\|ps1\|ps2\|xbox" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                    mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
                fi
                ;;
            "gba")
                # Try to find GBA-specific ROMs
                grep -i "advance\|gba" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                
                # If we found a good number of GBA ROMs, use those
                local gba_count=$(wc -l < "${TEMP_FILE}.filtered")
                if [ "$gba_count" -gt 50 ]; then
                    mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
                else
                    # Otherwise, use all ROMs and just exclude obvious non-GBA ones
                    mv "${TEMP_FILE}.all" "$TEMP_FILE"
                    grep -v -i "genesis\|megadrive\|32x\|sega\|nes\|snes\|nintendo\|playstation\|ps1\|ps2\|xbox" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                    mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
                fi
                ;;
            "gg")
                # Try to find GG-specific ROMs
                grep -i "gamegear\|gg" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                
                # If we found a good number of GG ROMs, use those
                local gg_count=$(wc -l < "${TEMP_FILE}.filtered")
                if [ "$gg_count" -gt 50 ]; then
                    mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
                else
                    # Otherwise, use all ROMs and just exclude obvious non-GG ones
                    mv "${TEMP_FILE}.all" "$TEMP_FILE"
                    grep -v -i "genesis\|megadrive\|32x\|sega\|nes\|snes\|nintendo\|playstation\|ps1\|ps2\|xbox" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                    mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
                fi
                ;;
            "ngp")
                # Try to find NGP-specific ROMs
                grep -i "neogeo\|ngp" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                
                # If we found a good number of NGP ROMs, use those
                local ngp_count=$(wc -l < "${TEMP_FILE}.filtered")
                if [ "$ngp_count" -gt 50 ]; then
                    mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
                else
                    # Otherwise, use all ROMs and just exclude obvious non-NGP ones
                    mv "${TEMP_FILE}.all" "$TEMP_FILE"
                    grep -v -i "genesis\|megadrive\|32x\|sega\|nes\|snes\|nintendo\|playstation\|ps1\|ps2\|xbox" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                    mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
                fi
                ;;
            "sms")
                # Try to find SMS-specific ROMs
                grep -i "master system\|mastersystem\|sms" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                
                # If we found a good number of SMS ROMs, use those
                local sms_count=$(wc -l < "${TEMP_FILE}.filtered")
                if [ "$sms_count" -gt 50 ]; then
                    mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
                else
                    # Otherwise, use all ROMs and just exclude obvious non-SMS ones
                    mv "${TEMP_FILE}.all" "$TEMP_FILE"
                    grep -v -i "genesis\|megadrive\|32x\|nes\|snes\|nintendo\|playstation\|ps1\|ps2\|xbox\|gameboy\|gba\|advance" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                    mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
                fi
                ;;
        esac
    fi
    
    # Decode URL-encoded filenames
    echo "Decoding URL-encoded filenames..."
    > "${TEMP_FILE}.decoded"
    while IFS= read -r line; do
        decoded=$(urldecode "$line")
        echo "$decoded" >> "${TEMP_FILE}.decoded"
    done < "$TEMP_FILE"
    mv "${TEMP_FILE}.decoded" "$TEMP_FILE"
    
    # Count the number of results before filtering by search term
    local total=$(wc -l < "$TEMP_FILE")
    echo "Found $total total ROMs in the archive for $(to_uppercase $platform) after filtering"
    
    if [ "$total" -eq 0 ]; then
        echo "No ROMs found for platform $(to_uppercase $platform)"
        echo "Trying alternative approach..."
        
        # Alternative approach: get all zip files and rely on user to select the right ones
        curl -s "$archive_url/" | grep -o '<a href="[^"]*\.zip">' | 
        sed 's/<a href="\([^"]*\)">/\1/' > "$TEMP_FILE"
        
        # Decode URL-encoded filenames
        > "${TEMP_FILE}.decoded"
        while IFS= read -r line; do
            decoded=$(urldecode "$line")
            echo "$decoded" >> "${TEMP_FILE}.decoded"
        done < "$TEMP_FILE"
        mv "${TEMP_FILE}.decoded" "$TEMP_FILE"
        
        total=$(wc -l < "$TEMP_FILE")
        echo "Found $total total zip files in the archive"
    fi
    
    # Count the number of results after filtering
    local count=$(wc -l < "$TEMP_FILE")
    
    if [ "$count" -eq 0 ]; then
        echo "No ROMs found matching '$search_term'"
        read -p "Press Enter to continue..."
        return 1
    else
        if [ -n "$search_term" ]; then
            echo "Found $count ROMs matching '$search_term'"
        else
            echo "Displaying all $count ROMs"
        fi
    fi
    
    echo ""
    
    # ROM selection loop - continue until user chooses to exit
    while true; do
        # Display results with numbers
        local i=1
        while read -r line; do
            # Extract just the filename without extension for display
            local display_name=$(basename "$line")
            echo "$i. $display_name"
            ((i++))
            
            # Add pagination for large lists
            if [ $((i % 20)) -eq 0 ]; then
                echo ""
                read -p "Press Enter to see more ROMs (or type 'q' to stop listing): " continue
                if [ "$continue" = "q" ]; then
                    break
                fi
            fi
        done < "$TEMP_FILE"
        
        echo ""
        echo "Options:"
        echo "  Enter a number to download a ROM"
        echo "  Enter 's' to search for a different ROM"
        echo "  Enter 'm' to return to the main menu"
        read -p "Your choice: " selection
        
        if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -gt 0 ] && [ "$selection" -le "$count" ]; then
            local selected_rom=$(sed "${selection}q;d" "$TEMP_FILE")
            download_rom "$selected_rom" "$platform"
            
            # After download, ask if user wants to download more ROMs
            echo ""
            echo "Options:"
            echo "  1. Download another ROM"
            echo "  2. Return to main menu"
            read -p "Your choice (1 or 2): " next_action
            
            if [ "$next_action" = "2" ]; then
                break
            fi
            # If they choose 1 or anything else, continue the loop to select another ROM
            
        elif [ "$selection" = "s" ]; then
            # Ask for a new search term
            echo ""
            read -p "Enter a new search term: " new_search_term
            search_roms "$new_search_term" "$platform"
            return 0
            
        elif [ "$selection" = "m" ]; then
            # Return to main menu
            break
            
        else
            echo "Invalid selection."
        fi
    done
}

# Function to download a ROM
download_rom() {
    local rom_file="$1"
    local platform="$2"
    
    # If platform is not provided, use the current platform
    if [ -z "$platform" ]; then
        platform="$CURRENT_PLATFORM"
    fi
    
    # Get the archive URL from the associative array
    local archive_url="${ARCHIVE_URLS[$platform]}"
    
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
    
    # Create platform directory if it doesn't exist
    mkdir -p "$platform_dir"
    
    # URL encode the ROM file for downloading
    local encoded_rom_file=$(echo "$rom_file" | sed 's/ /%20/g')
    
    # Construct the full download URL
    local download_url="${archive_url}/${encoded_rom_file}"
    echo "Download URL: $download_url"
    
    # Download the ROM file
    curl -s -L -o "$platform_dir/$decoded_rom_name" "$download_url"
    
    if [ $? -eq 0 ]; then
        echo "Download successful!"
        echo "ROM saved to: $platform_dir/$decoded_rom_name"
    else
        echo "Error downloading ROM. Please try again."
    fi
    
    # Ask if user wants to open the destination folder
    read -p "Open destination folder? (y/n): " open_folder
    if [ "$open_folder" = "y" ] || [ "$open_folder" = "Y" ]; then
        open_roms_folder
    fi
    
    # No 'Press Enter to continue' here - let the calling function handle the flow
}

# Function to download all ROMs for a platform
download_all_roms() {
    local platform="$CURRENT_PLATFORM"
    
    # Get the archive URL from the associative array
    local archive_url="${ARCHIVE_URLS[$platform]}"
    
    if [ -z "$archive_url" ]; then
        echo "Error: No archive URL found for platform $(to_uppercase $platform)"
        read -p "Press Enter to continue..."
        return 1
    fi
    
    echo "Downloading all ROMs for $(to_uppercase $platform) platform..."
    echo "Archive URL: $archive_url"
    
    # Get the list of ROMs from the archive
    echo "Fetching ROM list..."
    
    # Get all zip files from the archive
    curl -s "$archive_url/" | grep -o '<a href="[^"]*\.zip">' | 
    sed 's/<a href="\([^"]*\)">/\1/' > "$TEMP_FILE"
    
    # Save all ROMs before filtering
    cp "$TEMP_FILE" "${TEMP_FILE}.all"
    
    # Less restrictive platform-specific filtering
    case "$platform" in
        "nes")
            # Try to find NES-specific ROMs
            grep -i "nes\|nintendo\|famicom" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
            
            # If we found a good number of NES ROMs, use those
            local nes_count=$(wc -l < "${TEMP_FILE}.filtered")
            if [ "$nes_count" -gt 50 ]; then
                mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
            else
                # Otherwise, use all ROMs and just exclude obvious non-NES ones
                mv "${TEMP_FILE}.all" "$TEMP_FILE"
                grep -v -i "genesis\|megadrive\|32x\|sega\|gameboy\|gba\|advance\|playstation\|ps1\|ps2\|xbox" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
            fi
            ;;
        "snes")
            # Try to find SNES-specific ROMs
            grep -i "snes\|super\|sfc" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
            
            # If we found a good number of SNES ROMs, use those
            local snes_count=$(wc -l < "${TEMP_FILE}.filtered")
            if [ "$snes_count" -gt 50 ]; then
                mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
                # Remove obvious non-SNES games
                grep -v -i "genesis\|megadrive\|32x\|sega\|gameboy\|gba\|advance\|playstation\|ps1\|ps2\|xbox" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
            else
                # Otherwise, use all ROMs and just exclude obvious non-SNES ones
                mv "${TEMP_FILE}.all" "$TEMP_FILE"
                grep -v -i "genesis\|megadrive\|32x\|sega\|gameboy\|gba\|advance\|playstation\|ps1\|ps2\|xbox" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
            fi
            ;;
        "genesis")
            # Try to find Genesis-specific ROMs
            grep -i "genesis\|mega\|sega\|32x\|md\|gen" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
            
            # If we found a good number of Genesis ROMs, use those
            local genesis_count=$(wc -l < "${TEMP_FILE}.filtered")
            if [ "$genesis_count" -gt 50 ]; then
                mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
                # Remove obvious non-Genesis games
                grep -v -i "nintendo\|nes\|snes\|famicom\|mario\|zelda\|gameboy\|gba\|advance\|playstation\|ps1\|ps2\|xbox" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
            else
                # Otherwise, use all ROMs and just exclude obvious non-Genesis ones
                mv "${TEMP_FILE}.all" "$TEMP_FILE"
                grep -v -i "nintendo\|nes\|snes\|famicom\|mario\|zelda\|gameboy\|gba\|advance\|playstation\|ps1\|ps2\|xbox" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
            fi
            ;;
        "gb")
            # Try to find GB-specific ROMs
            grep -i "gameboy\|game boy\|gb\|gbc" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
            
            # If we found a good number of GB ROMs, use those
            local gb_count=$(wc -l < "${TEMP_FILE}.filtered")
            if [ "$gb_count" -gt 50 ]; then
                mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
                # Remove GBA games
                grep -v -i "advance\|gba" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
            else
                # Otherwise, use all ROMs and just exclude obvious non-GB ones
                mv "${TEMP_FILE}.all" "$TEMP_FILE"
                grep -v -i "genesis\|megadrive\|32x\|sega\|advance\|gba\|playstation\|ps1\|ps2\|xbox" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
            fi
            ;;
        "gba")
            # Try to find GBA-specific ROMs
            grep -i "advance\|gba" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
            
            # If we found a good number of GBA ROMs, use those
            local gba_count=$(wc -l < "${TEMP_FILE}.filtered")
            if [ "$gba_count" -gt 50 ]; then
                mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
            else
                # Otherwise, use all ROMs and just exclude obvious non-GBA ones
                mv "${TEMP_FILE}.all" "$TEMP_FILE"
                grep -v -i "genesis\|megadrive\|32x\|sega\|nes\|snes\|nintendo\|playstation\|ps1\|ps2\|xbox" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
            fi
            ;;
        "gg")
            # Try to find GG-specific ROMs
            grep -i "gamegear\|gg" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
            
            # If we found a good number of GG ROMs, use those
            local gg_count=$(wc -l < "${TEMP_FILE}.filtered")
            if [ "$gg_count" -gt 50 ]; then
                mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
            else
                # Otherwise, use all ROMs and just exclude obvious non-GG ones
                mv "${TEMP_FILE}.all" "$TEMP_FILE"
                grep -v -i "genesis\|megadrive\|32x\|sega\|nes\|snes\|nintendo\|playstation\|ps1\|ps2\|xbox" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
            fi
            ;;
        "ngp")
            # Try to find NGP-specific ROMs
            grep -i "neogeo\|ngp" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
            
            # If we found a good number of NGP ROMs, use those
            local ngp_count=$(wc -l < "${TEMP_FILE}.filtered")
            if [ "$ngp_count" -gt 50 ]; then
                mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
            else
                # Otherwise, use all ROMs and just exclude obvious non-NGP ones
                mv "${TEMP_FILE}.all" "$TEMP_FILE"
                grep -v -i "genesis\|megadrive\|32x\|sega\|nes\|snes\|nintendo\|playstation\|ps1\|ps2\|xbox" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
            fi
            ;;
        "sms")
            # Try to find SMS-specific ROMs
            grep -i "master system\|mastersystem\|sms" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
            
            # If we found a good number of SMS ROMs, use those
            local sms_count=$(wc -l < "${TEMP_FILE}.filtered")
            if [ "$sms_count" -gt 50 ]; then
                mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
            else
                # Otherwise, use all ROMs and just exclude obvious non-SMS ones
                mv "${TEMP_FILE}.all" "$TEMP_FILE"
                grep -v -i "genesis\|megadrive\|32x\|nes\|snes\|nintendo\|playstation\|ps1\|ps2\|xbox\|gameboy\|gba\|advance" "$TEMP_FILE" > "${TEMP_FILE}.filtered"
                mv "${TEMP_FILE}.filtered" "$TEMP_FILE"
            fi
            ;;
    esac
    
    # Decode URL-encoded filenames
    echo "Decoding URL-encoded filenames..."
    > "${TEMP_FILE}.decoded"
    while IFS= read -r line; do
        decoded=$(urldecode "$line")
        echo "$decoded" >> "${TEMP_FILE}.decoded"
    done < "$TEMP_FILE"
    mv "${TEMP_FILE}.decoded" "$TEMP_FILE"
    
    # Count the number of results after filtering
    local count=$(wc -l < "$TEMP_FILE")
    
    if [ "$count" -eq 0 ]; then
        echo "No ROMs found for platform $(to_uppercase $platform)"
        echo "Trying alternative approach..."
        
        # Alternative approach: get all zip files and rely on user to select the right ones
        curl -s "$archive_url/" | grep -o '<a href="[^"]*\.zip">' | 
        sed 's/<a href="\([^"]*\)">/\1/' > "$TEMP_FILE"
        
        # Decode URL-encoded filenames
        > "${TEMP_FILE}.decoded"
        while IFS= read -r line; do
            decoded=$(urldecode "$line")
            echo "$decoded" >> "${TEMP_FILE}.decoded"
        done < "$TEMP_FILE"
        mv "${TEMP_FILE}.decoded" "$TEMP_FILE"
        
        count=$(wc -l < "$TEMP_FILE")
        echo "Found $count total zip files in the archive"
    fi
    
    echo "Found $count ROMs for $(to_uppercase $platform) platform"
    
    # Ask for confirmation before downloading all ROMs
    read -p "Do you want to download all $count ROMs? (y/n): " confirm
    
    if [ "$confirm" != "y" ]; then
        echo "Download canceled."
        read -p "Press Enter to continue..."
        return 0
    fi
    
    # Get the correct platform directory
    local platform_dir=$(get_platform_dir "$platform")
    
    # Create platform directory if it doesn't exist
    mkdir -p "$platform_dir"
    
    echo "Downloading ROMs to $platform_dir..."
    
    # Download each ROM
    local i=1
    while read -r rom_file; do
        echo "Downloading ROM $i/$count: $rom_file"
        
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
    done < "$TEMP_FILE"
    
    echo "Download complete. $count ROMs downloaded to $platform_dir"
    
    # Ask if user wants to open the destination folder
    read -p "Open destination folder? (y/n): " open_folder
    if [ "$open_folder" = "y" ] || [ "$open_folder" = "Y" ]; then
        open_roms_folder
    fi
    
    read -p "Press Enter to continue..."
    return 0
}

# Function to verify ROM directories
verify_rom_directories() {
    echo "Verifying ROM directories..."
    
    # Check base directory
    if [ -d "$ROMS_BASE_DIR" ]; then
        echo " Base directory exists: $ROMS_BASE_DIR"
    else
        echo " Base directory does not exist: $ROMS_BASE_DIR"
        echo "Creating base directory..."
        mkdir -p "$ROMS_BASE_DIR"
        echo " Base directory created: $ROMS_BASE_DIR"
    fi
    
    # Check NES directory
    local nes_dir=$(get_platform_dir "nes")
    if [ -d "$nes_dir" ]; then
        local nes_count=$(find "$nes_dir" -type f | wc -l)
        echo " NES directory exists: $nes_dir (Contains $nes_count files)"
    else
        echo " NES directory does not exist: $nes_dir"
        echo "Creating NES directory..."
        mkdir -p "$nes_dir"
        echo " NES directory created: $nes_dir"
    fi
    
    # Check SNES directory
    local snes_dir=$(get_platform_dir "snes")
    if [ -d "$snes_dir" ]; then
        local snes_count=$(find "$snes_dir" -type f | wc -l)
        echo " SNES directory exists: $snes_dir (Contains $snes_count files)"
    else
        echo " SNES directory does not exist: $snes_dir"
        echo "Creating SNES directory..."
        mkdir -p "$snes_dir"
        echo " SNES directory created: $snes_dir"
    fi
    
    # Check Genesis directory
    local genesis_dir=$(get_platform_dir "genesis")
    if [ -d "$genesis_dir" ]; then
        local genesis_count=$(find "$genesis_dir" -type f | wc -l)
        echo " Genesis directory exists: $genesis_dir (Contains $genesis_count files)"
    else
        echo " Genesis directory does not exist: $genesis_dir"
        echo "Creating Genesis directory..."
        mkdir -p "$genesis_dir"
        echo " Genesis directory created: $genesis_dir"
    fi
    
    # Check GB directory
    local gb_dir=$(get_platform_dir "gb")
    if [ -d "$gb_dir" ]; then
        local gb_count=$(find "$gb_dir" -type f | wc -l)
        echo " GB directory exists: $gb_dir (Contains $gb_count files)"
    else
        echo " GB directory does not exist: $gb_dir"
        echo "Creating GB directory..."
        mkdir -p "$gb_dir"
        echo " GB directory created: $gb_dir"
    fi
    
    # Check GBA directory
    local gba_dir=$(get_platform_dir "gba")
    if [ -d "$gba_dir" ]; then
        local gba_count=$(find "$gba_dir" -type f | wc -l)
        echo " GBA directory exists: $gba_dir (Contains $gba_count files)"
    else
        echo " GBA directory does not exist: $gba_dir"
        echo "Creating GBA directory..."
        mkdir -p "$gba_dir"
        echo " GBA directory created: $gba_dir"
    fi
    
    # Check GG directory
    local gg_dir=$(get_platform_dir "gg")
    if [ -d "$gg_dir" ]; then
        local gg_count=$(find "$gg_dir" -type f | wc -l)
        echo " Game Gear directory exists: $gg_dir (Contains $gg_count files)"
    else
        echo " Game Gear directory does not exist: $gg_dir"
        echo "Creating Game Gear directory..."
        mkdir -p "$gg_dir"
        echo " Game Gear directory created: $gg_dir"
    fi
    
    # Check NGP directory
    local ngp_dir=$(get_platform_dir "ngp")
    if [ -d "$ngp_dir" ]; then
        local ngp_count=$(find "$ngp_dir" -type f | wc -l)
        echo " NeoGeo Pocket directory exists: $ngp_dir (Contains $ngp_count files)"
    else
        echo " NeoGeo Pocket directory does not exist: $ngp_dir"
        echo "Creating NeoGeo Pocket directory..."
        mkdir -p "$ngp_dir"
        echo " NeoGeo Pocket directory created: $ngp_dir"
    fi
    
    # Check SMS directory
    local sms_dir=$(get_platform_dir "sms")
    if [ -d "$sms_dir" ]; then
        local sms_count=$(find "$sms_dir" -type f | wc -l)
        echo " Master System directory exists: $sms_dir (Contains $sms_count files)"
    else
        echo " Master System directory does not exist: $sms_dir"
        echo "Creating Master System directory..."
        mkdir -p "$sms_dir"
        echo " Master System directory created: $sms_dir"
    fi
    
    echo "ROM directory verification complete."
    read -p "Press Enter to continue..."
}

# Function to test archive URLs
test_archive_urls() {
    clear
    echo "===== Testing Archive URLs ====="
    
    for platform in "${!ARCHIVE_URLS[@]}"; do
        local archive_url="${ARCHIVE_URLS[$platform]}"
        
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
    local old_base_dir="$HOME/Desktop/$(whoami)/games-roms"
    local new_base_dir="$ROMS_BASE_DIR"
    
    echo "Copying ROMs from $old_base_dir to $new_base_dir..."
    
    # Check if source directory exists
    if [ ! -d "$old_base_dir" ]; then
        echo "Source directory $old_base_dir does not exist. Nothing to copy."
        read -p "Press Enter to continue..."
        return 1
    fi
    
    # Check if destination directory exists, create if not
    if [ ! -d "$new_base_dir" ]; then
        echo "Destination directory $new_base_dir does not exist. Creating it..."
        mkdir -p "$new_base_dir"
        if [ $? -ne 0 ]; then
            echo "Failed to create destination directory $new_base_dir. Please check permissions."
            read -p "Press Enter to continue..."
            return 1
        fi
    fi
    
    # Copy each platform's ROMs
    for platform in "nes" "snes" "genesis" "gb" "gba" "gg" "ngp" "sms"; do
        local src_dir="$old_base_dir/$platform"
        local dst_dir="$new_base_dir/$platform"
        
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
    
    set_roms_base_dir
    
    while true; do
        show_menu
        read -p "Enter your choice: " choice
        
        case $choice in
            1)
                clear
                echo "===== Search ROMs ====="
                echo "Available platforms: NES, SNES, Genesis, GB, GBA, GG, NeoGeo Pocket, Master System"
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
                echo "Available platforms: NES, SNES, Genesis, GB, GBA, GG, NeoGeo Pocket, Master System"
                select_platform
                search_roms "" "$CURRENT_PLATFORM"
                ;;
            3)
                clear
                echo "===== Download All ROMs ====="
                echo "Available platforms: NES, SNES, Genesis, GB, GBA, GG, NeoGeo Pocket, Master System"
                echo "This will download all ROMs from the archive."
                select_platform
                read -p "Continue? (y/n): " confirm
                if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
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
trap "rm -f $TEMP_FILE" EXIT

# Start the main menu
main_menu
