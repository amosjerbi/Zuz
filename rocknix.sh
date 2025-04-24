#!/bin/sh

# Set platform so it will save in the correct directory
PLATFORM="nes"

# Set the target directory for ROM downloads this is for rocknix mounted path
ROM_DIR="$HOME/games-internal/roms/$PLATFORM"
# If you want to save to desktop ROM_DIR="$HOME/Desktop/roms/$PLATFORM"

# Create ROM directory if it doesn't exist
mkdir -p "$ROM_DIR"
cd "$ROM_DIR" || exit 1

# Define your search terms here, add more search terms as needed
SEARCH_TERMS=(
    "cat"
)

# List of mirror URLs to try downloading from, add more URLs as needed
URLS=(
    "https:/kagi.com"
    "https://google.com"
)

# Process each search term
for search_term in "${SEARCH_TERMS[@]}"; do
    echo "====================================="
    echo "Searching for $PLATFORM ROMs containing: $search_term"
    echo "====================================="
    
    # Download files matching current search term
    for url in "${URLS[@]}"; do
        echo "Checking $url for files matching '$search_term'..."
        
        # Get file listing from URL and filter by search term
        wget -q -O - "$url" | grep -i "$search_term" | grep -o 'href="[^"]*"' | cut -d'"' -f2 | while read -r file; do
            # Skip directories and non-zip files
            if [[ "$file" == */* ]] || [[ "$file" != *.zip ]]; then
                continue
            fi
            
            download_url="${url}${file}"
            echo "Downloading $file..."
            wget \
                --no-check-certificate \
                --timeout=30 \
                --tries=3 \
                -q \
                --show-progress \
                "$download_url" -P "$ROM_DIR"
        done
    done
done

echo "All matching $PLATFORM ROM downloads completed"
